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

@property (nonatomic, strong) NSString * item;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * colour;
@property (nonatomic, assign) BOOL flag;
@end
