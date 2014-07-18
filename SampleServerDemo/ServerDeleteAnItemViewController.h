//
//  ServerDeleteAnItemViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCValidatedTextField.h>
    
@interface ServerDeleteAnItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *codeStatus;
@property (weak, nonatomic) IBOutlet CCValidatedTextField *code;
@end
