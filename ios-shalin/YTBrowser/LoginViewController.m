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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a reference to a Firebase location
    fb = [[Firebase alloc] initWithUrl:@"https://youparty.firebaseio.com/"];
    
    NSLog(fb.description);
//    [[fb childByAppendingPath:@"ssdsd"] setValue:@"testerino"];
    
    // Write data to Firebase
    usernameLabel.delegate = self;
    loginLabel.delegate = self;
    
    
    usernameLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    usernameLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    usernameLabel.layer.borderWidth= 1.0f;
    usernameLabel.layer.cornerRadius=8.0f;
    
    loginLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    loginLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    loginLabel.layer.borderWidth= 1.0f;
    loginLabel.layer.cornerRadius=8.0f;
    
    //[usernameLabel setBackgroundColor:[UIColor clearColor]];
    //[loginLabel setBackgroundColor:[UIColor clearColor]];
    
    //[usernameLabel setTextColor: [UIColor whiteColor]];
    //[loginLabel setTextColor: [UIColor whiteColor]];
    
    //[self setUpNewPlaylist:@"YCHacks"];
    
    //[self addSongToPlaylist:@"YCHacks" url:@"X2F4EFYM_MA" videoname:@"nomnom"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-160,320,400);
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameLabel) {
        [textField resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,0,320,400);
        [UIView commitAnimations];
        
        
        //Firebase* users = [fb childByAppendingPath:@"users"];
        
        if ([textField.text isEqualToString:@""]) {
            
        } else {

        
        [self setUpNewUser:textField.text];
        
        [self addPlaylistToUser:textField.text playlist:@"YCHacks"];
        
        [self addPlaylistToUser:textField.text playlist:@"music"];
        
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"username"];
        
        PlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideosView"];
        [self presentViewController:vc animated:YES completion:nil];
        
        textField.text = @"";
        }
        
        return NO;
    }
    
    if (textField == loginLabel) {
        [textField resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,0,320,400);
        [UIView commitAnimations];
        
        //Firebase* users = [fb childByAppendingPath:@"users"];
        
        //[self setUpNewUser:textField.text];
        if ([textField.text isEqualToString:@""]) {
            
        } else {
            //make upper
        
        [[NSUserDefaults standardUserDefaults] setValue:[textField.text uppercaseString] forKey:@"username"];
        
        PlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideosView"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        textField.text = @"";
        }
        
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