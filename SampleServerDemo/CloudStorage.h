//
//  CloudStorage.h
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "DataHandler.h"


//typedef void (^Success)(NSArray *array);
//typedef void (^Failure)(NSError *error);

@interface CloudStorage : DataHandler <NSURLConnectionDataDelegate>

    @property (strong, nonatomic) Success successRequestCallBack;
    @property (nonatomic, strong) Failure failureCallback;

    - (void )getRequest:(NSString *)queryString requestSucceeded:(void (^)(NSArray *array))success requestFailed:(void (^)(NSError *error))failure;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;

@end
