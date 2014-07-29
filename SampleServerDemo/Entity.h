//
//  Entity.h
//  SampleServerDemo
//
//  Created by qbadmin on 24/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * colour;

@end
