//
//  GetNewViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 16/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "GetNewViewController.h"
#import "ListedViewController.h"
#import "ServerAppDelegate.h"
#import "Entity.h"


@interface GetNewViewController (){
    NSMutableData *responseData;
    NSMutableArray *array;
    NSMutableString *queryString;
}

@end


@implementation GetNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    responseData = [NSMutableData data];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.search.enabled=YES;
}


- (IBAction)search:(id)sender {
    self.search.enabled=NO;
    array=[[NSMutableArray alloc]init];
    [self.view endEditing:YES];
    
    queryString=[[NSMutableString alloc] initWithString:
                 @"http://10.3.0.145:9000/Sample3/DBConnector"];
    [queryString appendString:[NSString stringWithFormat:
                               @"?Item=%@&Code=%@&Colour=%@",
                               self.item.text,
                               self.code.text,
                               self.colour.text]];
    StoreManager *manager= [[StoreManager alloc] init];
    DataHandler *object = [manager getStore];
    [object getRequest:queryString];
}



#pragma mark- TextField Delegates
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



#pragma mark- DataHandler Delegate
- (void)refreshPage:(NSMutableArray*)arrayOfObjects{
    array=arrayOfObjects;
    [self performSegueWithIdentifier:@"showGet" sender:self];
}



#pragma mark - Segue and Memory Management
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ListedViewController*list=[segue destinationViewController];
    list.array=array;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
