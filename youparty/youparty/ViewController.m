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
    
    [self setUpNewUser:@"Kevin"];
    
    [self setUpNewUser:@"Gautam"];
    
    [self setUpNewUser:@"Shalin"];
    
    [self setUpNewPlaylist:@"YCHacks"];
    
    [self setUpNewPlaylist:@"ios dev music"];
    
    [self addSongToPlaylist:@"YCHacks" url:@"yt.com/trololol" videoname:@"troll"];
    
    [self addSongToPlaylist:@"YCHacks" url:@"yc.com/hacks" videoname:@"y?"];
    
    [self addSongToPlaylist:@"ios dev music" url:@"yt.com/yc" videoname:@"HackYC"];
    
    [self addPlaylistToUser:@"Kevin" playlist:@"YCHacks"];
    [self addPlaylistToUser:@"Kevin" playlist:@"ios dev music"];
    
    [self addPlaylistToUser:@"Shalin" playlist:@"YCHacks"];
    [self addPlaylistToUser:@"Shalin" playlist:@"ios dev music"];
    
    [self addPlaylistToUser:@"Gautam" playlist:@"YCHacks"];
   
}

-(void) addPlaylistToUser:(NSString*) user playlist:(NSString*)playlist
{
    Firebase* users = [fb childByAppendingPath:@"users"];
    Firebase* myself = [users childByAppendingPath:user];
    Firebase* playists = [myself childByAppendingPath:@"playlists"];
    [[playists childByAutoId] setValue:playlist];
}

-(void) setUpNewUser:(NSString*) username
{
    Firebase* users = [fb childByAppendingPath:@"users"];
    
    [users setValue:@"k"];
    
    NSString* name = username;
    
    Firebase* myself = [users childByAppendingPath:name];
    
    [[myself childByAppendingPath:@"name"] setValue:name];
    
    Firebase* playists = [myself childByAppendingPath:@"playlists"];
    
    [playists setValue:@"insert playlist here"];
}


-(void) setUpNewPlaylist:(NSString*) name
{
    Firebase* playlists = [fb childByAppendingPath:@"playlists"];
    NSString* playlistname = name;
    Firebase* theplaylist = [playlists childByAppendingPath:playlistname];
    [[theplaylist childByAppendingPath:@"name"] setValue:playlistname];
    Firebase* videos = [theplaylist childByAppendingPath:@"videos"];
    [videos setValue:@"insert videos part of playlist here"];
}


-(void) addSongToPlaylist:(NSString*) playlist url:(NSString*)url videoname:(NSString*)videoname
{
    Firebase* playlists = [fb childByAppendingPath:@"playlists"];
    Firebase* theplaylist = [playlists childByAppendingPath:playlist];
    Firebase* videos = [theplaylist childByAppendingPath:@"videos"];
    Firebase* video = [videos childByAutoId];
    [[video childByAppendingPath:@"name"] setValue:videoname];
    [[video childByAppendingPath:@"url"] setValue:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
