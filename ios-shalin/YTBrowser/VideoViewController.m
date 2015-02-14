//
//  VideoViewController.m
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "VideoViewController.h"
#import "ViewController.h"
#import "LivePlayViewController.h"
#import "PBJViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
{
    NSMutableArray* videos;
}

@synthesize tableView;
@synthesize playButton;
@synthesize vidButton;
//@synthesize playlistName;
@synthesize backButton;

// fixes orientation issues that the user may have
-(BOOL)shouldAutorotate {
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}




-(void) buttonAction
{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YoutubeView"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    videos = [[NSMutableArray alloc] init];
    
//    [videos addObject:@"DpSaTrW4leg"];
    
    NSString* badvariablenames = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    //NSLog(badvariablenames);
    
    NSString *hi = [NSString stringWithFormat:@"https://youparty.firebaseio.com/%@",badvariablenames];
    
    Firebase* videolist = [[[Firebase alloc] initWithUrl:hi] childByAppendingPath:@"queue"];
    
    //NSLog(@"%@", videolist.description);
    
    [vidButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    [playButton addTarget:self action:@selector(moveToLiveView) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    
    [videolist observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        //NSLog(@"%@",snapshot.value);
        
        
        
        NSArray *keys = [snapshot.value allKeys];
        NSLog(@"%@",keys);
//        NSMutableArray *urls = [NSMutableArray new];
        if (keys.count == 0 || !keys) {
        } else {
            NSLog(@"madeit");
//            NSLog(@"%@",snapshot.value);
            for (NSString *key in keys) {
                NSLog(@"%@ ,%@",key,snapshot.value[key]);
                [videos addObject:snapshot.value[key]];
            }
        }
        
        
        // Reload the table view so the new message will show up.
        
        [tableView reloadData];
        
    }];
    
    
//    [videolist observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        // Add the chat message to the array.
//        //NSLog(@"%@",snapshot.value);
//        
//        
//        
//        [videos addObject:snapshot.value[@"url"]];
//        
//        // Reload the table view so the new message will show up.
//        
//        [tableView reloadData];
//        
//    }];
    
//    Firebase* theplaylistloc = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://youparty.firebaseio.com/playlists/%@",badvariablenames]];
//    
//    [theplaylistloc observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        
//        //NSLog(@"%@",snapshot.value[@"name"]);
//        
//            playlistName.text = snapshot.value[@"name"];
//        
//        
//    }];
}

-(void) goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) moveToLiveView
{
//    if([videos count] >= 1)
//    {
//        LivePlayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LivePlayView"];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[videos objectAtIndex:0] forKey:@"videourl"];
    NSLog(@"vid at %@",[videos objectAtIndex:0]);
    
    PBJViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomPlayer"];
    
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //NSLog(@"okokok");
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UILabel* title;
    UILabel* detail;
    UIImageView* thumbnail;
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 230, 60)];
        title.backgroundColor = [UIColor clearColor];
        title.numberOfLines = 1;
        title.textColor = [UIColor whiteColor];
        //title.lineBreakMode = UILineBreakModeWordWrap;
        title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        
        detail = [[UILabel alloc] initWithFrame:CGRectMake(97, 40, 230, 60)];
        detail.backgroundColor = [UIColor clearColor];
        detail.textColor = [UIColor whiteColor];
        detail.numberOfLines = 0;
        detail.lineBreakMode = UILineBreakModeWordWrap;
        detail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        
        thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 60)];
    }
    
    [cell addSubview:title];
    [cell addSubview:detail];
    [cell addSubview:thumbnail];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textColor = [UIColor whiteColor];
    
    NSString* urlInString = [videos objectAtIndex:index.row];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=jsonc",urlInString]]];
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
    
    detail.text = [NSString stringWithFormat:@"%d",index.row];//[NSString stringWithFormat:@"youtube.com/%@",chatMessage[@"url"]];
    [detail sizeToFit];
    
    NSString* url = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",urlInString];
    
    thumbnail.image = [UIImage imageNamed:@"thumbnail.png"];
    
    //NSLog(url);
    
    //NSString *imageUrl = @"http://www.foo.com/myImage.jpg";
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        thumbnail.image = [UIImage imageWithData:data];
    }];
    
    //cell.textLabel.text = chatMessage[@"name"];
    //cell.detailTextLabel.text = chatMessage[@"url"];
    
    //
    
    
    return cell;
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