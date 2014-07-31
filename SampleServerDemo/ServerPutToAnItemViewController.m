//
//  ServerPutToAnItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerPutToAnItemViewController.h"

@interface ServerPutToAnItemViewController ()

@end

@implementation ServerPutToAnItemViewController

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
    RAC(self.submit, enabled) = [RACSignal
                                       combineLatest:@[ self.item.rac_textSignal, self.code.rac_textSignal, self.colour.rac_textSignal]
                                       reduce:^(NSString *itemText, NSString *codeText, NSString *colorText) {
                                           
                                           NSString *itemPattern = @"[A-Z0-9a-z@!&]";
                                           NSString *codePattern = @"[0-9]$";
                                           NSString *colourPattern = @"[A-Za-z@!&]";
                                           
                                           return @([self validateString:itemText withPattern:itemPattern] && [self validateString:codeText withPattern:codePattern] && [self validateString:colorText withPattern:colourPattern]);
                                       }];


}
-(void) viewWillAppear:(BOOL)animated{
    [self.view reloadInputViews];
    [self initializeViews];
}

-(void) initializeViews{
    self.item.text=@"";
    self.code.text=@"";
    self.colour.text=@"";
}

- (IBAction)editAnItem:(id)sender {
    [self.view endEditing:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
    [request setHTTPMethod:@"PUT"];
    NSString *post = [NSString stringWithFormat:@"%@/%@/%@/",self.item.text,self.code.text,self.colour.text];
    NSData *requestBodyData = [post dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _item) {
        [_code becomeFirstResponder];
    }else if (textField == _code) {
        [_colour becomeFirstResponder];
    }else if (textField == _colour) {
        [self editAnItem:self];
    }
    return YES;
}

#pragma mark - NSURL delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Resposnse Received");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Data Received");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    [Utilities showAlert:@"Woohoo ! It's done " withTitle:@"Success!"];
}


- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
