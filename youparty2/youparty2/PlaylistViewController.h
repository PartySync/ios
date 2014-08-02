//
//  PlaylistViewController.h
//  youparty2
//
//  Created by Kevin Frans on 8/2/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface PlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
