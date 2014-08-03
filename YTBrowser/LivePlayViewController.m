//
//  LivePlayViewController.m
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "LivePlayViewController.h"
#import <Firebase/Firebase.h>

@interface LivePlayViewController ()

@end

@implementation LivePlayViewController

@synthesize player, tableView, webPlayer;

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
    
    NSString *hi = [NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@/videos",badvariablenames];
    
    Firebase *videolist = [[Firebase alloc] initWithUrl:hi];

    [videolist observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [videos addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        [self.tableView reloadData];
        
    }];
    player.delegate = self;
    }
-(void) viewWillAppear:(BOOL)animated {
    dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
        [self updatePlaylist];
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
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Cell";
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 230, 60)];
    title.backgroundColor = [UIColor clearColor];
    title.numberOfLines = 0;
    title.lineBreakMode = UILineBreakModeWordWrap;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    
    UILabel* detail = [[UILabel alloc] initWithFrame:CGRectMake(97, 40, 230, 60)];
    detail.backgroundColor = [UIColor clearColor];
    detail.numberOfLines = 0;
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
    
    NSDictionary* chatMessage = [videos objectAtIndex:index.row];
    
    [videoURLs addObject:chatMessage[@"url"]];
    
    title.text = chatMessage[@"name"];
    [title sizeToFit];
    
    detail.text = [NSString stringWithFormat:@"youtube.com/%@",chatMessage[@"url"]];
    [detail sizeToFit];
    
    NSString* url = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",chatMessage[@"url"]];
    
    thumbnail.image = [UIImage imageNamed:@"thumbnail.png"];
    
    //NSLog(url);
    
    //NSString *imageUrl = @"http://www.foo.com/myImage.jpg";
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        thumbnail.image = [UIImage imageWithData:data];
    }];
    
    return cell;
}
-(void) updatePlaylist {
//    for (int i = 0; i < [videoURLs count]; i++) {
    
//        if (videoNumber == 0) {
//            [player loadWithVideoId:[NSString stringWithFormat:@"%@", videoURLs[videoNumber]]];
//
//        } else {
//            [player loadVideoById:[NSString stringWithFormat:@"%@", videoURLs[i]] startSeconds:<#(float)#> suggestedQuality:<#(YTPlaybackQuality)#>:videoURLs[i] index:i startSeconds:0 suggestedQuality:kYTPlaybackQualityLarge];
//        }
//    }
    
    NSString *url = [NSString stringWithFormat:@"https://www.youtube.com/v/%@?autoplay=1&playsinline=1&rel=0&playlist=", videoURLs[0]];

    NSString *htmlString = [NSString stringWithFormat:@"<html><head>\
                            <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>\
                            <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
                            <iframe id=\"ytplayer\" type=\"text/html\" width=\"320\" height=\"240\"\
                            src=\"%@\"\
                            frameborder=\"0\"/>\
                            </body></html>", url];
    
    
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html"];
//    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//    [webView loadHTMLString:htmlString baseURL:nil];
//    
    NSString *newString;
    
    for (int i = 1; i < [videoURLs count]; i++) {
        newString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@,", videoURLs[i]]];
    }
    
    
    [webPlayer loadHTMLString:newString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];

}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        case kYTPlayerStateEnded:
            videoNumber += 1;
            [self updatePlaylist];
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
