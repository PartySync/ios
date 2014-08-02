//
//  PlaylistViewController.m
//  youparty2
//
//  Created by Kevin Frans on 8/2/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController
{
    Firebase* fb;
    NSMutableArray* playlists;
}

@synthesize tableView;

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
    
    [user observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [playlists addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        
        [tableView reloadData];
        
        NSLog(@"thing, %d",[playlists count]);
        
//        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playlists.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    }];
    
    
    
    
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

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    //NSLog(@"okokok");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* chatMessage = [playlists objectAtIndex:index.row];
    
    cell.textLabel.text = chatMessage;
    
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
