//
//  PlaylistViewController.m
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import "PlaylistViewController.h"
#import "VideoViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController
{
    Firebase* fb;
    NSMutableArray* playlists;
}

@synthesize tableView,addNewPlaylist,backButton,playlistLabel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    playlists = [[NSMutableArray alloc] init];
    
    tableView.delegate = self;
    
    fb = [[Firebase alloc] initWithUrl:@"https://youparty.firebaseio.com/"];
    
    Firebase* user = [[[fb childByAppendingPath:@"users"] childByAppendingPath:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]] childByAppendingPath:@"playlists"];
    
    NSLog([user description]);
    
    playlistLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"add a playlist" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    playlistLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    playlistLabel.layer.borderWidth= 1.0f;
    playlistLabel.layer.cornerRadius=8.0f;
    
    playlistLabel.delegate = self;
    
    [user observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [playlists addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        
        [tableView reloadData];
        
        NSLog(@"thing, %d",[playlists count]);
        
        //        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playlists.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    }];
    
    [addNewPlaylist addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    
    
    
}

-(void) goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) buttonAction
{
    if(![playlistLabel.text isEqualToString:@""])
    {
        Firebase* playlistsf = [fb childByAppendingPath:@"playlists"];
        NSString* playlistname = playlistLabel.text;
        Firebase* theplaylist = [playlistsf childByAppendingPath:playlistname];
        [[theplaylist childByAppendingPath:@"name"] setValue:playlistname];
        Firebase* videos = [theplaylist childByAppendingPath:@"videos"];
        //[videos setValue:@"insert videos part of playlist here"];
        
        Firebase* users = [fb childByAppendingPath:@"users"];
        Firebase* myself = [users childByAppendingPath:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
        Firebase* playists = [myself childByAppendingPath:@"playlists"];
        [[playists childByAutoId] setValue:playlistname];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,320,400);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == playlistLabel) {
        [textField resignFirstResponder];
        [self buttonAction];
        return NO;
    }
    return YES;
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
    return [playlists count];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSString* playlistname = [playlists objectAtIndex:indexPath.row];
    NSLog(playlistname);
    [[NSUserDefaults standardUserDefaults] setObject:playlistname forKey:@"playlistname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideosView"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-160,320,400);
    [UIView commitAnimations];
    
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    //NSLog(@"okokok");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString* chatMessage = [playlists objectAtIndex:index.row];
    
    cell.textLabel.text = chatMessage;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textColor = [UIColor whiteColor];
    
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