//
//  ListedViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 18/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ListedViewController.h"
#import "ItemCell.h"

@interface ListedViewController (){
    NSArray *arrayOfContents;
    NSMutableData *responseData;
    NSMutableString *queryString;
}

@end

@implementation ListedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    responseData = [NSMutableData data];
    arrayOfContents=[NSArray arrayWithArray:_array];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self makeARequestCall];
        [self.tableView.pullToRefreshView stopAnimating];
    } withBackgroundColor:[UIColor lightGrayColor]];
    
    [RACObserve(self.searchBar, text)
     subscribeNext:^(NSString *newName) {
         [self makeARequestCall];
     }];
    
    
    RACSignal *signal = [self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)];
    
    __weak typeof(self)weakSelf = self;
    
    [signal subscribeNext:^(RACTuple *arguments) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.searchBar == arguments.first) {
            [self makeARequestCall];
        }
    }];
    
}




-(void) makeARequestCall{
    queryString=[[NSMutableString alloc ]initWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"];
    [queryString appendString:[NSString stringWithFormat:@"?Item=%@&Code=%@&Colour=%@",self.searchBar.text,self.searchBar.text,self.searchBar.text]];
    NSLog(@"%@",queryString);
    [self sendRequest];
}




- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
}




-(void) sendRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}



- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar {
    [self.view endEditing:YES];
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
    if(responseData){
    arrayOfContents = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    }
    NSLog(@"%@",arrayOfContents);
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfContents.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.item.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Item"];
    cell.code.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Code"];
    cell.colour.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Colour"];
    return cell;
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
