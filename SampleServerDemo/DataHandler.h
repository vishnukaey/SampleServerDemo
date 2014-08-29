//
//  DataHandler.h
//  SampleServerDemo
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^Success)(NSArray *array);
typedef void (^Failure)(NSError *error);

@interface DataHandler : NSObject

    @property (strong, nonatomic) Success successRequestCallBack;
    @property (nonatomic, strong) Failure failureCallback;

    - (void )getRequest:(NSString *)queryString requestSucceeded:(void (^)(NSArray *array))success requestFailed:(void (^)(NSError *error))failure;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;
@end
