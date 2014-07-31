
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
    NSMutableData *responseData;
    NSMutableArray *array;    
}
@end

@implementation DataHandler

-(id) init
{
    self = [super init];
    if(self)
    {
        array=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void ) getRequest:(NSString *) queryString{
    responseData = [NSMutableData data];
    NSLog(@"Datahandler get");
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    if(appDelegate.isReachable){
        [self sendRequest:queryString];
    }
    else{
        NSLog(@"Loading the cached Data from device... ");
        [self loadFromDevice];
        [self getValuesFromLoadedArray];
        NSLog(@"%@",array);
        [self.delegate refreshPage:array];
    }
}


- (void)postRequest:(NSString *)queryString{
    
}


- (void)putRequest:(NSString *)queryString{
    
}


- (void)deleteRequest:(NSString *)queryString{
    
}




#pragma mark - Helping Methods
-(void) sendRequest:(NSString*)queryString{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}

-(void) saveToDevice{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSError *error;
    [self deleteAllData];
    for(int i=0;i<array.count;i++){
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                   inManagedObjectContext:context];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Item"] forKey:@"item"];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Code"] forKey:@"code"];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Colour"] forKey:@"colour"];
    }
    [context save:&error];
}



-(void)deleteAllData{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    for(NSManagedObject *object in loadedArray){
        [context deleteObject:object];
    }
}



-(void) getValuesFromLoadedArray{
    for (Entity *entity in loadedArray) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:entity.item forKey:@"Item"];
        [dict setObject:entity.code forKey:@"Code"];
        [dict setObject:entity.colour forKey:@"Colour"];
        [array addObject:dict];
    }
}


-(void) loadFromDevice{
    ServerAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Entity" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    loadedArray=[moc executeFetchRequest:request error:&error];
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
    array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSLog(@"%@",array);
    [self.delegate refreshPage:array];
}

@end






