//
//  LivePlayViewController.m
//  youParty
//
//  Created by Kevin Frans on 8/3/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "LivePlayViewController.h"
#import <Firebase/Firebase.h>

@interface LivePlayViewController ()

@end

@implementation LivePlayViewController

@synthesize player, tableView, backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    videoNumber = 0;
    
    videoURLs = [[NSMutableArray alloc] init];
    videos = [[NSMutableArray alloc] init];
    
    NSString* badvariablenames = [[NSUserDefaults standardUserDefaults] stringForKey:@"playlistname"];
    
    //NSLog(badvariablenames);
    
    NSString *hi = [NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@/videos",badvariablenames];
    
    Firebase *videolist = [[Firebase alloc] initWithUrl:hi];
    
    //NSLog(@"%@", videolist.description);
    
    [backButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    
    
    [videolist observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [videos addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        
        [self.tableView reloadData];
//        [self updatePlaylist];
        
        
    }];
    
    Firebase* firebaseRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@/",badvariablenames]];
    
    [firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%f",[snapshot.value[@"currentVidTime"] floatValue]);
        NSLog(@"%f",[snapshot.value[@"currentVid"] floatValue]);
        
        currentTime = [snapshot.value[@"currentVidTime"] floatValue];
        currentVid = snapshot.value[@"currentVid"];
    }];
    
    player.delegate = self;
    
}


-(void) buttonAction
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
        [self updatePlaylist];
    });
    
    dispatch_time_t countdownTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
    dispatch_after(countdownTime2, dispatch_get_main_queue(), ^(void){
        [player playVideo];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [videos count];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    //    NSString* playlistname = [videos objectAtIndex:indexPath.row];
    //    [[NSUserDefaults standardUserDefaults] setValue:videos forKey:@"playlistname"];
    //
    //    VideoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Videos"];
    //    [self presentViewController:vc animated:YES completion:nil];
    [player playVideo];
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Cell";
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 230, 60)];
    title.backgroundColor = [UIColor clearColor];
    title.numberOfLines = 0;
    title.textColor = [UIColor whiteColor];
    title.lineBreakMode = UILineBreakModeWordWrap;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    
    UILabel* detail = [[UILabel alloc] initWithFrame:CGRectMake(97, 40, 230, 60)];
    detail.backgroundColor = [UIColor clearColor];
    detail.numberOfLines = 0;
    detail.textColor = [UIColor whiteColor];
    detail.lineBreakMode = UILineBreakModeWordWrap;
    detail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    
    UIImageView* thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 60)];
    
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell addSubview:title];
    [cell addSubview:detail];
    [cell addSubview:thumbnail];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary* chatMessage = [videos objectAtIndex:index.row];
    
    [videoURLs addObject:chatMessage[@"url"]];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=jsonc",chatMessage[@"url"]]]];
    NSError *error=nil;
    NSDictionary *response=[NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error];
    //NSString* sth=[response objectForKey: @"some_your_key"];
    
    NSString* titlestring = [[response objectForKey:@"data"] objectForKey:@"title"];
    
    if(titlestring.length > 20)
    {
        titlestring = [NSString stringWithFormat:@"%@...",[titlestring substringToIndex:18]];
    }
    
    title.text = titlestring;//chatMessage[@"name"];
    [title sizeToFit];

    
    detail.text = [NSString stringWithFormat:@"youtube.com/%@",chatMessage[@"url"]];
    [detail sizeToFit];
    
    NSString* url = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",chatMessage[@"url"]];
    
    thumbnail.image = [UIImage imageNamed:@"thumbnail.png"];
    
    //NSLog(url);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        thumbnail.image = [UIImage imageWithData:data];
    }];
    
    return cell;
}
-(void) updatePlaylist {
    
    //[player playVideo];
    [player loadWithVideoId:currentVid];
//    [player loadVideoById:[NSString stringWithFormat:@"%f", currentVid] startSeconds:0 suggestedQuality:@"strong"];
}

-(void) playVideoDelay
{
    dispatch_time_t countdownTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(countdownTime2, dispatch_get_main_queue(), ^(void){
        [player playVideo];
    });
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
//        case k
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        case kYTPlayerStateEnded:
            videoNumber += 1;
            [self updatePlaylist];
            [self playVideoDelay];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
