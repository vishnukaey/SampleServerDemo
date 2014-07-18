//
//  ServerListAllItemsViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerListAllItemsViewController.h"
#import "ItemCell.h"

@interface ServerListAllItemsViewController (){
    NSArray *arrayOfContents;
}

@end

@implementation ServerListAllItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{   [super viewDidLoad];
    arrayOfContents=[NSArray arrayWithArray:_array];
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [self.delegate sendRequest];
//        [self.tableView reloadData];
//        [self.tableView.pullToRefreshView stopAnimating];
//    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void) refreshTable{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return arrayOfContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.item.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Item"];
    cell.code.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Code"];
    cell.colour.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Colour"];
    return cell;
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
