
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



-(void ) getRequest:(NSString *) queryString{
    NSLog(@" Super instance Cretaed");
//    requestMethodType=@"GET";
//    NSLog(@"Datahandler Getting");
//    responseData = [NSMutableData data];
//    
//    if(isReachable){
//        NSLog(@"Loading Data ONLINE ");
//        [self sendRequest:queryString ofType:requestMethodType];
//    }
//    else{
//        NSLog(@"Loading the cached Data OFFLINE ");
//        [self loadFromDevice];
//        [self getValuesFromLoadedArray];
//        [self.delegate refreshPage:array];
//        NSLog(@"%@",array);
//    }
}


- (void)postRequest:(NSString *)queryString{
//    requestMethodType=@"POST";
//    if(isReachable){
//        NSLog(@"Datahandler Posting ONLINE");
//        [self sendHttpRequest:queryString ofType:requestMethodType];
//    }
//    else {
//        NSLog(@"Datahandler Posting OFFLINE");
//        [self sendOfflineRequest:[self getItemFromQueryString:queryString]];
//    }
}


- (void)putRequest:(NSString *)queryString{
//    requestMethodType=@"PUT";
//    if(isReachable){
//        NSLog(@"Datahandler Putting ONLINE");
//        [self sendHttpRequest:queryString ofType:requestMethodType];
//    }
//    else {
//        NSLog(@"Datahandler Putting OFFLINE");
//        [self sendOfflineRequest:[self getItemFromQueryString:queryString]];
//    }
//    
}


- (void)deleteRequest:(NSString *)queryString{
//    requestMethodType=@"DELETE";
//    if(isReachable){
//        NSLog(@"Datahandler Deleting ONLINE");
//        [self sendHttpRequest:queryString ofType:requestMethodType];
//    }
//    else {
//        NSLog(@"Datahandler Deleting OFFLINE");
//        
//        [self sendOfflineRequest:@[@"%@",queryString]];
//    }
}

@end






