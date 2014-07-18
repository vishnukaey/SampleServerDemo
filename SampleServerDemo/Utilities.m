//
//  SeatingLayoutViewController.m
//  Please Sit
//
//  Created by Vishnu on 01/07/14.
//  Copyright (c) 2014 Qburst. All rights reserved.



#import "Utilities.h"
@implementation Utilities

+ (void) showAlert:(NSString *)message withTitle:(NSString *)title {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
@end
