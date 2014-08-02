//
//  ViewController.m
//  youparty
//
//  Created by Kevin Frans on 8/2/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            

@end

@implementation ViewController
{
    Firebase* fb;
}
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a reference to a Firebase location
    fb = [[Firebase alloc] initWithUrl:@"https://youparty.firebaseio.com/"];
    // Write data to Firebase
    [fb setValue:@"Do you have data? You'll love Firebase."];
    
    [self setUpNewUser];
    
    [self setUpNewPlaylist];
    
   
}

-(void) setUpNewUser
{
    Firebase* users = [fb childByAppendingPath:@"users"];
    
    [users setValue:@"k"];
    
    NSString* name = @"Kevin";
    
    Firebase* myself = [users childByAppendingPath:name];
    
    [[myself childByAppendingPath:@"name"] setValue:name];
    
    Firebase* playists = [myself childByAppendingPath:@"playlists"];
    
    [playists setValue:@"insert playlist here"];
}


-(void) setUpNewPlaylist
{
    Firebase* playlists = [fb childByAppendingPath:@"playlists"];
    NSString* playlistname = @"YCHacks";
    Firebase* theplaylist = [playlists childByAppendingPath:playlistname];
    [[theplaylist childByAppendingPath:@"name"] setValue:playlistname];
    Firebase* users = [theplaylist childByAppendingPath:@"users"];
    [users setValue:@"insert users part of playlist here"];
}


-(void) addSongToPlaylist:(NSString*) user
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
