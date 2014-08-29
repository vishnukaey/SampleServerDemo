
//
//  DataHandler.m
//  SampleServerDemo
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "DataHandler.h"
#import "ListedViewController.h"

@interface DataHandler(){
    NSArray *loadedArray;
    Reachability *reach;

}
@end

@implementation DataHandler


- (void )getRequest:(NSString *)queryString requestSucceeded:(void (^)(NSArray *array))success requestFailed:(void (^)(NSError *error))failure{
}


- (void)postRequest:(NSString *)queryString{
}


- (void)putRequest:(NSString *)queryString{
}


- (void)deleteRequest:(NSString *)queryString{
}

@end






