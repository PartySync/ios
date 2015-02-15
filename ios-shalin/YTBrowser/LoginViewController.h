//
//  LoginViewController.h
//  youParty
//
//  Created by Shalin Shah on 8/2/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *loginLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameLabel;


@end
