//
//  OfflineStorage.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.

#import "OfflineStorage.h"
#import "ConnectivityAnalyzer.h"


@implementation OfflineStorage{
    NSMutableArray *array;
    NSArray *loadedArray;
    NSString *requestMethodType;
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Overridden Methods


- (void)getRequest:(NSString *)queryString{
     NSLog(@"GET - OFFLINE");
    [self loadFromDevice];
    [self getValuesFromLoadedArray];
}

- (void )postRequest:(NSString *)queryString{
     NSLog(@"POST - OFFLINE");
    requestMethodType = @"POST";
    NSArray *values=[self getItemFromQueryString:queryString];
    [self sendOfflineRequest:values];
    
}

- (void )putRequest:(NSString *)queryString{
     NSLog(@"PUT - OFFLINE");
    requestMethodType = @"PUT";
    NSArray *values=[self getItemFromQueryString:queryString];
    [self sendOfflineRequest:values];
}

- (void )deleteRequest:(NSString *)queryString{
     NSLog(@"DELETE - OFFLINE");
    requestMethodType = @"DELETE";
    NSArray *values=[self getItemFromQueryString:queryString];
    [self sendOfflineRequest:values];
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
    array = [[NSMutableArray alloc] init];
    for (Entity *entity in loadedArray) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:entity.item forKey:@"Item"];
        [dict setObject:entity.code forKey:@"Code"];
        [dict setObject:entity.colour forKey:@"Colour"];
        [array addObject:dict];
    }
    NSLog(@"%@",array);
}

-(NSArray*)getItemFromQueryString:(NSString*)queryString{
    NSArray *item;
    item=[queryString componentsSeparatedByString:@"/"];
    return item;
}

-(void)sendOfflineRequest:(NSArray*)requestParam{
    [self loadFromDevice];
    for(Entity *entity in loadedArray)
    {
        if([entity.item isEqualToString:[requestParam objectAtIndex:1]]){
            if([requestMethodType isEqualToString:@"POST"]){
                entity.flag=1;
                entity.item=[requestParam objectAtIndex:0];
                entity.colour=[requestParam objectAtIndex:2];
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
    loadedArray = [[NSArray alloc] init];
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Entity" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    loadedArray=[moc executeFetchRequest:request error:&error];
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

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}


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

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
