//
//  ServerPushNewItemViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCValidatedTextField.h>
#import <DQAlertView.h>

@interface ServerPushNewItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet CCValidatedTextField  *item;
@property (weak, nonatomic) IBOutlet UIImageView *emailStatus;
@property (weak, nonatomic) IBOutlet CCValidatedTextField *code;
@property (weak, nonatomic) IBOutlet CCValidatedTextField *colour;
@property (weak, nonatomic) IBOutlet UIImageView *codeStatus;
@property (weak, nonatomic) IBOutlet UIImageView *colourStatus;

@end
