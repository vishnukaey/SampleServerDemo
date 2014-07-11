//
//  ForGoogleViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 10/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForGoogleViewController : UIViewController<NSURLConnectionDelegate>{
    NSMutableData *responseData;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
