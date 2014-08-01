
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
    Reachability *reach;
    bool isReachable;
    NSString *requestMethodType;
}
@end

@implementation DataHandler
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id) init
{
    self = [super init];
    if(self)
    {
        array=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void) reachabilityCheck{
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self)weakSelf = self;
    reach.reachableBlock = ^(Reachability*reach)
    {
        __strong typeof (self)strongSelf=weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf->isReachable=YES;
            NSLog(@"REACHABLE!");
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        __strong typeof (self)strongSelf=weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf->isReachable=YES;
            NSLog(@"UNREACHABLE!");
        });
    };
    
    [reach startNotifier];
}


-(void ) getRequest:(NSString *) queryString{
    requestMethodType=@"GET";
    NSLog(@"Datahandler Getting");
    responseData = [NSMutableData data];
    
    if(isReachable){
        NSLog(@"Loading Data ONLINE ");
        [self sendRequest:queryString ofType:requestMethodType];
    }
    else{
        NSLog(@"Loading the cached Data OFFLINE ");
        [self loadFromDevice];
        [self getValuesFromLoadedArray];
        [self.delegate refreshPage:array];
        NSLog(@"%@",array);
    }
}


- (void)postRequest:(NSString *)queryString{
    requestMethodType=@"POST";
    if(isReachable){
        NSLog(@"Datahandler Posting ONLINE");
        [self sendHttpRequest:queryString ofType:requestMethodType];
    }
    else {
        NSLog(@"Datahandler Posting OFFLINE");
        [self sendOfflineRequest:[self getItemFromQueryString:queryString]];
    }
}


- (void)putRequest:(NSString *)queryString{
    requestMethodType=@"PUT";
    if(isReachable){
        NSLog(@"Datahandler Putting ONLINE");
        [self sendHttpRequest:queryString ofType:requestMethodType];
    }
    else {
        NSLog(@"Datahandler Putting OFFLINE");
        [self sendOfflineRequest:[self getItemFromQueryString:queryString]];
    }
    
}


- (void)deleteRequest:(NSString *)queryString{
    requestMethodType=@"DELETE";
    if(isReachable){
        NSLog(@"Datahandler Deleting ONLINE");
        [self sendHttpRequest:queryString ofType:requestMethodType];
    }
    else {
        NSLog(@"Datahandler Deleting OFFLINE");
        [self sendOfflineRequest:queryString];
    }
}



#pragma mark - Helping Methods
-(void) sendRequest:(NSString*)queryString ofType:(NSString*)methodType{
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
                                    [NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
    [request setHTTPMethod:methodType];
    NSData *requestBodyData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}

-(void) saveToDevice{
    NSManagedObjectContext *context =
    [self managedObjectContext];
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
    NSManagedObjectContext *context =
    [self managedObjectContext];
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

-(NSString*)getItemFromQueryString:(NSString*)queryString{
    NSString *item;
    item=[[queryString componentsSeparatedByString:@"/"] objectAtIndex:1];
    return item;
}
-(void)sendOfflineRequest:(NSString*)item{
    [self loadFromDevice];
    for(Entity *entity in loadedArray)
    {
        if([entity.code isEqualToString:item]){
            if([requestMethodType isEqualToString:@"POST"]){
                entity.flag=1;
            }
    
            else if([requestMethodType isEqualToString:@"PUT"]){
                entity.flag=2;
            }
            else if([requestMethodType isEqualToString:@"DELETE"]){
                entity.flag=3;
            }
            break;
        }
    }
}

-(void) loadFromDevice{
    NSManagedObjectContext *moc = [self managedObjectContext];
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
    if([requestMethodType isEqualToString:@"GET"]){
    array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSLog(@"%@",array);
    [self.delegate refreshPage:array];
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl =[[self applicationDocumentsDirectory]
                      URLByAppendingPathComponent: @"Entity.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end






