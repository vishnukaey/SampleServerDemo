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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RAC(self.submit, enabled) = [RACSignal combineLatest:@[ self.item.rac_textSignal,
                                                            self.code.rac_textSignal,
                                                            self.colour.rac_textSignal
                                                            ]
                                       reduce:^(NSString *itemText,
                                                NSString *codeText,
                                                NSString *colorText
                                                ){
                                           NSString *itemPattern = @"[A-Z0-9a-z@!&]";
                                           NSString *codePattern = @"[0-9]$";
                                           NSString *colourPattern = @"[A-Za-z@!&]";
                                           return @(
                                              [self validateString:itemText withPattern:itemPattern]
                                           && [self validateString:codeText withPattern:codePattern]
                                           && [self validateString:colorText withPattern:colourPattern]
                                           );
                                       }
                                 ];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initializeFields];
}


-(void) initializeFields{
    self.item.text=@"";
    self.code.text=@"";
    self.colour.text=@"";
}


- (IBAction)editAnItem:(id)sender {
    [self.view endEditing:YES];
    DataHandler *handler= [[DataHandler alloc]init];
    NSString *putString = [NSString stringWithFormat:
                           @"%@/%@/%@/",
                           self.item.text,
                           self.code.text,
                           self.colour.text];
    [handler putRequest:putString];
}

- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}


#pragma mark- TextField delegates
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark- Memory Warning

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
