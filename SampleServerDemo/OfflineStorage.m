//
//  OfflineStorage.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.

#import "OfflineStorage.h"
#import "ConnectivityAnalyzer.h"



@implementation OfflineStorage

#pragma mark - Overridden Methods

- (void)getRequest:(NSString *)queryString requestSucceeded:(void (^)(NSArray *))success requestFailed:(void (^)(NSError *))failure{
     NSLog(@"GET - OFFLINE");
    NSError *error;
    NSArray *allEntities = [self getValuesFromLoadedArray:[self loadFromDevice]];
    self.successRequestCallBack = success;
    self.failureCallback = failure;
    NSArray *undeletedEntries = [self getUndeletedEntitites:allEntities];
    if(undeletedEntries)
        self.successRequestCallBack(undeletedEntries);
    else
        self.failureCallback(error);
    
}


- (void )postRequest:(NSString *)queryString{
     NSLog(@"POST - OFFLINE");
    [self sendOfflineRequest:@"POST" withEntity:[self getObjectFromQueryString:queryString]];
}


- (void )putRequest:(NSString *)queryString{
     NSLog(@"PUT - OFFLINE");
    [self sendOfflineRequest:@"PUT" withEntity:[self getObjectFromQueryString:queryString]];
}


- (void )deleteRequest:(NSString *)queryString{
     NSLog(@"DELETE - OFFLINE");
    [self sendOfflineRequest:@"DELETE" withEntity:[self getObjectFromQueryString:queryString]];
}


- (NSArray*)getRequest{
    return [self getValuesFromLoadedArray:[self loadFromDevice]];
}


-(void)sendOfflineRequest:(NSString*)requestMethodType withEntity:(NSArray*)currentEntity{
    if([requestMethodType isEqualToString:@"POST"])
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:
                      @"Entity" inManagedObjectContext:context];
        [newContact setValue:[currentEntity objectAtIndex:0] forKey:@"Item"];
        [newContact setValue:[currentEntity objectAtIndex:1] forKey:@"Code"];
        [newContact setValue:[currentEntity objectAtIndex:2] forKey:@"Colour"];
        [newContact setValue:@"" forKey:@"flag"];
        [context save:&error];
    }
        
    NSArray *loadedArray=[self loadFromDevice];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    ConnectivityAnalyzer *connection = [ConnectivityAnalyzer instance];
    for(NSManagedObject *entity in loadedArray)
    {
        NSString *currentEntityCode;
        if([requestMethodType isEqualToString:@"DELETE"])
            currentEntityCode=[currentEntity objectAtIndex:0];
        else
            currentEntityCode=[currentEntity objectAtIndex:1];
        
        if([[entity valueForKey:@"code"] isEqualToString:currentEntityCode] && !connection.canConnectToInternet){
            if([requestMethodType isEqualToString:@"POST"]){
                [entity setValue:@"1" forKey:@"flag"];
            }
            else if([requestMethodType isEqualToString:@"PUT"]){
                [entity setValue:@"2" forKey:@"flag"];
                [entity setValue:[currentEntity objectAtIndex:0] forKey:@"item"];
                [entity setValue:[currentEntity objectAtIndex:2] forKey:@"colour"];
            }
            else if([requestMethodType isEqualToString:@"DELETE"]){
                [entity setValue:@"3" forKey:@"flag"];
            }
            break;
        }
    }
    [context save:&error];
}



-(NSArray*)getObjectFromQueryString:(NSString*)queryString{
    NSArray *item;
    item=[queryString componentsSeparatedByString:@"/"];
        return item;
}


-(NSArray *) getUndeletedEntitites:(NSArray*) array{
    NSMutableArray *undeletedArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < array.count ; i++){
        NSDictionary *dict = [array objectAtIndex:i];
        if(![[dict valueForKey:@"flag"] isEqual:@"3"]){
            [undeletedArray addObject:dict];
        }
    }
    return undeletedArray;
}

-(void)deletePermanently:(NSString *)queryString{
    NSArray *loadedArray=[self loadFromDevice];
    NSManagedObjectContext *context = [self managedObjectContext];
    for(NSManagedObject *entity in loadedArray)
    {
        if([[entity valueForKey:@"code"] isEqualToString:queryString]){
            [context deleteObject:entity];
        }
    }
}


-(NSArray *) loadFromDevice{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Entity" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    return [moc executeFetchRequest:request error:&error];

}


-(NSMutableArray*) getValuesFromLoadedArray:(NSArray*)loadedArray{
    NSMutableArray *array= [[NSMutableArray alloc] init];
    for (Entity *entity in loadedArray) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:entity.item forKey:@"Item"];
        [dict setObject:entity.code forKey:@"Code"];
        [dict setObject:entity.colour forKey:@"Colour"];
        [dict setObject:entity.flag forKey:@"flag"];
        [array addObject:dict];
    }
    return array;
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
