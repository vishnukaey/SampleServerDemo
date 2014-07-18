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
    [self validateFields];

}
-(void) viewWillAppear:(BOOL)animated{
    [self.view reloadInputViews];
    [self initializeViews];
}

-(void) initializeViews{
    self.item.text=@"";
    self.code.text=@"";
    self.colour.text=@"";
    self.emailStatus.image=[UIImage imageNamed:@""];
    self.codeStatus.image=[UIImage imageNamed:@""];
    self.colourStatus.image=[UIImage imageNamed:@""];
}

- (IBAction)editAnItem:(id)sender {
    [self.view endEditing:YES];
    if([self.item.text  isEqualToString:@""] || [self.code.text  isEqualToString:@""] || [self.colour.text  isEqualToString:@""]){
        [Utilities showAlert:@"Ahh! No Hurry. Please fill the fields" withTitle:@"Error"];
        return;
    }
    if(_item.valid && _code.valid && _colour.valid ){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
        [request setHTTPMethod:@"PUT"];
        NSString *post = [NSString stringWithFormat:@"%@/%@/%@/",self.item.text,self.code.text,self.colour.text];
        NSData *requestBodyData = [post dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn){
            NSLog(@"No Connection");
        }
    }
    else{
        [Utilities showAlert:@"Ahh! Careful. Wrong Fromats" withTitle:@"Error"];
        return;
        
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

-(void) validateFields{
    NSString *itemPattern = @"[A-Z0-9a-z@!&]";
    _item.validationBlock = ^(NSString *text) {
        return [self validateString:text withPattern:itemPattern];
    };
    _item.postValidationBlock = ^(BOOL valid){
        if ( valid ) {
            _emailStatus.image = [UIImage imageNamed:@"valid"];
        } else {
            _emailStatus.image = [UIImage imageNamed:@"invalid"];
        }
    };
    NSString *codePattern = @"[0-9@!&]";
    _code.validationBlock = ^(NSString *text) {
        return [self validateString:text withPattern:codePattern];
    };
    _code.postValidationBlock = ^(BOOL valid){
        if ( valid ) {
            _codeStatus.image = [UIImage imageNamed:@"valid"];
        } else {
            _codeStatus.image = [UIImage imageNamed:@"invalid"];
        }
    };
    NSString *colourPattern = @"[A-Za-z@!&]";
    _colour.validationBlock = ^(NSString *text) {
        return [self validateString:text withPattern:colourPattern];
    };
    _colour.postValidationBlock = ^(BOOL valid){
        if ( valid ) {
            _colourStatus.image = [UIImage imageNamed:@"valid"];
        } else {
            _colourStatus.image = [UIImage imageNamed:@"invalid"];
        }
    };
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
