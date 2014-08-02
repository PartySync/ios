//
//  YTViewController.h
//  youparty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGBox.h"
#import "MGScrollView.h"

#import "JSONModelLib.h"
#import "VideoModel.h"

#import "PhotoBox.h"
#import "WebVideoViewController.h"

@interface YTViewController : UIViewController {
    IBOutlet MGScrollView *scroller;
    MGBox* searchBox;
    NSArray* videos;
}

@end
