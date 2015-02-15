//
//  WebVideoViewController.m
//  YTBrowser
//
//  Created by Marin Todorov on 09/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "WebVideoViewController.h"

@implementation WebVideoViewController
{
    IBOutlet UIWebView* webView;
    NSString* videoId;
}

@synthesize addButton;
@synthesize fakeSegueButton;

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


-(void) viewDidLoad {
    playIDArray = [[NSMutableArray alloc] init];
    
    VideoLink* link = self.video.link[0];
    
    NSString* videoId = nil;
    
    NSArray *queryComponents = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString* pair in queryComponents) {
        NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
        if ([pairComponents[0] isEqualToString:@"v"]) {
            videoId = pairComponents[1];
            break;
        }
    }
    
    if (!videoId) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
        return;
    }
    
    NSLog(@"Embed video id: %@", videoId);
    
//    [self.playerView loadWithVideoId:[NSString stringWithFormat:@"%@", videoId]];\
    
    
    
    
    
    [self displayGoogleVideo];
    
    
    
    
    
    
    
    
    
    [addButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [fakeSegueButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
    [super viewDidLoad];
}


- (void) displayGoogleVideo

{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGSize screenSize = rect.size;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
    
    webView.autoresizesSubviews = YES;
    
    webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSString *videoUrl = @"http://www.youtube.com/v/oHg5SJYRHA0"; // valid youtube url
    
    
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"320\" height=\"480\"><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"480\"></embed></object></div></body></html>",videoUrl,videoUrl]    ;
    
    
    
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
    
    
    [self.view addSubview:webView];
    
//    [webView release]; 
    
}

-(void)viewDidAppear:(BOOL)animated
{
    VideoLink* link = self.video.link[0];
    
    videoId = nil;
    
    NSArray *queryComponents = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString* pair in queryComponents) {
        NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
        if ([pairComponents[0] isEqualToString:@"v"]) {
            videoId = pairComponents[1];
            break;
        }
    }
    
    if (!videoId) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
        return;
    }
    
    NSLog(@"Embed video id: %@", videoId);
    
    [self.playerView loadWithVideoId:[NSString stringWithFormat:@"%@", videoId]];
    
    [playIDArray addObject:[NSString stringWithFormat:@"%@", videoId]];
    [[NSUserDefaults standardUserDefaults] setObject:playIDArray forKey:@"videoIDs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) buttonAction
{
    //NSLog(videoId);
    
    NSString* playlist = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSLog(@"%@ llololol",playlist);
    
    Firebase* fb = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://youparty.firebaseio.com/%@",playlist]];
        Firebase* playlists = [fb childByAppendingPath:@"queue"];
    NSLog(playlists.description);
//    Firebase* theplaylist = [fb childByAppendingPath:];
//    Firebase* videos = [theplaylist childByAppendingPath:@"queue"];
    Firebase* video = [playlists childByAutoId];
    [video setValue:videoId];
    
    [self backButtonAction];

}

-(void) backButtonAction
{
    //NSLog(videoId);
    
    [self dismissModalViewControllerAnimated:YES];
    
}


//-(void) addSongToPlaylist:(NSString*) playlist url:(NSString*)url videoname:(NSString*)videoname
//{
//    Firebase* fb = [[Firebase alloc] initWithUrl:@"https://youparty.firebaseio.com/"];
//    Firebase* playlists = [fb childByAppendingPath:@"playlists"];
//    Firebase* theplaylist = [playlists childByAppendingPath:playlist];
//    Firebase* videos = [theplaylist childByAppendingPath:@"videos"];
//    Firebase* video = [videos childByAutoId];
//}

//    NSString *htmlString = @"<html><head>\
//    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>\
//    <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
//    <iframe id=\"ytplayer\" type=\"text/html\" width=\"320\" height=\"240\"\
//    src=\"http://www.youtube.com/embed/%@?autoplay=1\"\
//    frameborder=\"0\"/>\
//    </body></html>";
//    
//    htmlString = [NSString stringWithFormat:htmlString, videoId, videoId];
//    
//    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
//
//    NSLog(@"This is the yt link: %@", link);
//    


@end
