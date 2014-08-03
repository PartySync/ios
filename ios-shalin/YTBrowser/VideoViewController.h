//
//  VideoViewController.h
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface VideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *playlistName;

@property (strong, nonatomic) IBOutlet UIButton *vidButton;

@property (strong, nonatomic) IBOutlet UIButton *playButton;


@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end