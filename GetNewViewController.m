//
//  GetNewViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 16/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "GetNewViewController.h"
#import "ServerListAllItemsViewController.h"

@interface GetNewViewController (){
    NSMutableData *responseData;
    NSArray *array;
    NSMutableString *queryString;
}

@end

@implementation GetNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    responseData = [NSMutableData data];
	// Do any additional setup after loading the view.
}

- (IBAction)search:(id)sender {
    queryString=[[NSMutableString alloc ]initWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"];
    [queryString appendString:[NSString stringWithFormat:@"?Item=%@&Code=%@&Colour=%@",self.item.text,self.code.text,self.colour.text]];
    NSLog(@"%@",queryString);
    [self sendRequest];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
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
    [self performSegueWithIdentifier:@"showGet" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ServerListAllItemsViewController *list=[segue destinationViewController];
    list.array=array;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
