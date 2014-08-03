//
//  ViewController.m
//  YTBrowser
//
//  Created by Marin Todorov on 03/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "ViewController.h"

#import "MGBox.h"
#import "MGScrollView.h"

#import "JSONModelLib.h"
#import "VideoModel.h"

#import "PhotoBox.h"
#import "WebVideoViewController.h"

@interface ViewController () <UITextFieldDelegate>
{
    IBOutlet MGScrollView* scroller;
    MGBox* searchBox;
    
    NSArray* videos;
}

@end

@implementation ViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //setup the scroll view
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.bottomPadding = 8;
    scroller.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];

    //setup the search box
    searchBox = [MGBox boxWithSize:CGSizeMake(320,44)];
    searchBox.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    //setup the search text field
    UITextField* fldSearch = [[UITextField alloc] initWithFrame:CGRectMake(4,4,312,35)];
    fldSearch.borderStyle = UITextBorderStyleRoundedRect;
    fldSearch.backgroundColor = [UIColor whiteColor];
    fldSearch.font = [UIFont systemFontOfSize:24];
    fldSearch.delegate = self;
    fldSearch.placeholder = @"Search YouTube...";
    fldSearch.text = @"rick roll";
    fldSearch.clearButtonMode = UITextFieldViewModeAlways;
    fldSearch.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [searchBox addSubview: fldSearch];
    
    //add search box
    [scroller.boxes addObject: searchBox];
    
    //fire up the first search
    [self searchYoutubeVideosForTerm: fldSearch.text];
    
    [backButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

}

-(void) buttonAction
{
    [self dismissModalViewControllerAnimated:YES];
}

//fire up API search on Enter pressed
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchYoutubeVideosForTerm:textField.text];
    return YES;
}

-(void)searchYoutubeVideosForTerm:(NSString*)term
{
    NSLog(@"Searching for '%@' ...", term);
    
    //URL escape the term
    term = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //make HTTP call
    NSString* searchCall = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&max-results=50&alt=json", term];

    [JSONHTTPClient getJSONFromURLWithString: searchCall
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      //got JSON back
                                      NSLog(@"Got JSON from web: %@", json);
                                      
                                      if (err) {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:[err localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                          return;
                                      }
                                      
                                      //initialize the models
                                      videos = [VideoModel arrayOfModelsFromDictionaries:
                                                json[@"feed"][@"entry"]
                                                ];
                                      
                                      if (videos) NSLog(@"Loaded successfully models");

                                      //show the videos
                                      [self showVideos];
                                      
                                  }];
}

-(void)showVideos
{
    //clean the old videos
    [scroller.boxes removeObjectsInRange:NSMakeRange(1, scroller.boxes.count-1)];
    
    //add boxes for all videos
    for (int i=0;i<videos.count;i++) {
        
        //get the data
        VideoModel* video = videos[i];
        MediaThumbnail* thumb = video.thumbnail[0];
        
        //create a box
        PhotoBox *box = [PhotoBox photoBoxForURL:thumb.url title:video.title];
        box.onTap = ^{
            WebVideoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
            vc.video = video;
            [self presentViewController:vc animated:YES completion:nil];
            //[self performSegueWithIdentifier:@"videoViewSegue" sender:video];
        };
        
        //add the box
        [scroller.boxes addObject:box];
    }
    
    //re-layout the scroll view
    [scroller layoutWithSpeed:0.3 completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebVideoViewController* controller = segue.destinationViewController;
    controller.video = sender;
    
    
}

@end
