//
//  LivePlayViewController.h
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface LivePlayViewController : UIViewController {
    NSMutableArray *videos;
    NSMutableArray *videoURLs;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet YTPlayerView *player;

@end