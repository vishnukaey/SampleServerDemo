//
//  CloudStorage.h
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "DataHandler.h"

@interface CloudStorage : DataHandler

    - (void)getRequest:(NSString *)queryString;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;

@end
