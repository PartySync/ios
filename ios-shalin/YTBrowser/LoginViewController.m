//
//  LoginViewController.m
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "PlaylistViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController
{
    Firebase *fb;
    //hi
}

@synthesize usernameLabel;
@synthesize loginLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a reference to a Firebase location
    fb = [[Firebase alloc] initWithUrl:@"https://youparty.firebaseio.com/"];
    // Write data to Firebase
    usernameLabel.delegate = self;
    loginLabel.delegate = self;
    
    //[self setUpNewPlaylist:@"YCHacks"];
    
    //[self addSongToPlaylist:@"YCHacks" url:@"X2F4EFYM_MA" videoname:@"nomnom"];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameLabel) {
        [textField resignFirstResponder];
        
        //Firebase* users = [fb childByAppendingPath:@"users"];
        
        [self setUpNewUser:textField.text];
        
        [self addPlaylistToUser:textField.text playlist:@"YCHacks"];
        
        [self addPlaylistToUser:textField.text playlist:@"music"];
        
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"username"];
        
        PlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistView"];
        [self presentViewController:vc animated:YES completion:nil];
        
        textField.text = @"";
        
        return NO;
    }
    
    if (textField == loginLabel) {
        [textField resignFirstResponder];
        
        //Firebase* users = [fb childByAppendingPath:@"users"];
        
        //[self setUpNewUser:textField.text];
        
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"username"];
        
        PlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistView"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        textField.text = @"";
        
        return NO;
    }
    return YES;
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
    NSString* name = username;
    Firebase* myself = [users childByAppendingPath:name];
    [[myself childByAppendingPath:@"name"] setValue:name];
    Firebase* playists = [myself childByAppendingPath:@"playlists"];
    [playists setValue:@"none"];
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
    [video setValue:@{@"name": videoname,@"url": url}];
//    [[video childByAppendingPath:@"name"] setValue:videoname];
//    [[video childByAppendingPath:@"url"] setValue:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end