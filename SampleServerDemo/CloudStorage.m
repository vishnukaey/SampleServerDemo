//
//  CloudStorage.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "CloudStorage.h"
#import "OfflineStorage.h"

@implementation CloudStorage{
    NSMutableData *responseData;
    NSString *requestMethodType;
    NSMutableArray *array;
}


#pragma mark - Overridden Methods
- (NSArray*)getRequest:(NSString *)queryString{
    NSLog(@"GET - CLOUD");
    [self sendRequest:queryString ofType:@"GET"];
    return 0;
}
- (void )postRequest:(NSString *)queryString{
     NSLog(@"POST - CLOUD");
    [self sendHttpRequest:queryString ofType:@"POST"];
}
- (void )putRequest:(NSString *)queryString{
     NSLog(@"PUT - CLOUD");
    [self sendHttpRequest:queryString ofType:@"PUT"];
}
- (void )deleteRequest:(NSString *)queryString{
     NSLog(@"DELETE - CLOUD");
    [self sendHttpRequest:queryString ofType:@"DELETE"];
}


#pragma mark - Helping Methods
-(void) sendRequest:(NSString*)queryString ofType:(NSString*)methodType{
    requestMethodType = methodType;
    array = [[NSMutableArray alloc]init];
    responseData = [[NSMutableData alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:queryString]];
    [request setHTTPMethod:methodType];
    
    
    
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
    
}

-(void) sendHttpRequest:(NSString*)queryString ofType:(NSString*)methodType{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:
                                     @"http://10.3.0.145:9000/Sample3/DBConnector"]];
    [request setHTTPMethod:methodType];
    NSData *requestBodyData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}


#pragma mark - NSURL delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
    NSLog(@"Resposnse Received");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    NSLog(@"Data Received");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    if([requestMethodType isEqualToString:@"GET"]){
        if(responseData)
        array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
        NSLog(@"%@",array);
        [self updateOnlineDatabaseWhenConnectionIsCreated];
    }
}

-(void) updateOnlineDatabaseWhenConnectionIsCreated{
    static bool now= YES;
    if(now)
    {
        now=NO;
        OfflineStorage *offline= [[OfflineStorage alloc] init];
        NSArray *offlineArray= [offline getRequest];
        for(int i = 0 ; i < offlineArray.count ; i++){
        if([[[offlineArray objectAtIndex:i] valueForKey:@"flag"] isEqualToString:@"1"]){
            [self postRequest:[NSString stringWithFormat:@"%@/%@/%@/",
                               [[offlineArray objectAtIndex:i] valueForKey:@"Item"],
                               [[offlineArray objectAtIndex:i] valueForKey:@"Code"],
                               [[offlineArray objectAtIndex:i] valueForKey:@"Colour"]]];
        }
        else if([[[offlineArray objectAtIndex:i] valueForKey:@"flag"] isEqualToString:@"2"]){
        [self postRequest:[NSString stringWithFormat:@"%@/%@/%@/",
                               [[offlineArray objectAtIndex:i] valueForKey:@"Item"],
                               [[offlineArray objectAtIndex:i] valueForKey:@"Code"],
                               [[offlineArray objectAtIndex:i] valueForKey:@"Colour"]]];
        }
        else{
            [self deleteRequest:[[offlineArray objectAtIndex:i] valueForKey:@"Code"] ];
        }
    }
    [offline deleteAllData];

    }
}

@end
