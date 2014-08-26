//
//  DataHandler.h
//  SampleServerDemo
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataHandler : NSObject
    - (NSArray*)getRequest:(NSString *)queryString;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;
@end
