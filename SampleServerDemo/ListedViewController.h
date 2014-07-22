//
//  ListedViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 18/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KoaPullToRefresh.h>
#import <ReactiveCocoa.h>

@interface ListedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *array;


@end
