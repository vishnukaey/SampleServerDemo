//
//  ServerPutToAnItemViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ServerPutToAnItemViewController : UIViewController
    @property (weak, nonatomic) IBOutlet UITextField  *item;
    @property (weak, nonatomic) IBOutlet UITextField *code;
    @property (weak, nonatomic) IBOutlet UITextField *colour;
    @property (weak, nonatomic) IBOutlet UIButton *submit;
@end
