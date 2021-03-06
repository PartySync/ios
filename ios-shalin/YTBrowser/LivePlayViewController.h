//
//  LivePlayViewController.h
//  youParty
//
//  Created by Kevin Frans on 8/3/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface LivePlayViewController : UIViewController <YTPlayerViewDelegate>
{
    NSMutableArray* videos;
    NSMutableArray* videoURLs;
    int videoNumber;
    float currentTime;
    NSString* currentVid;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet YTPlayerView *player;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@end
