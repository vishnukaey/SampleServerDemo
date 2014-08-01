//
//  ServerPushNewItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerPushNewItemViewController.h"
#import "Entity.h"


@interface ServerPushNewItemViewController (){
    NSArray *loadedArray;
}
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation ServerPushNewItemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    DataHandler *handler=[[DataHandler alloc]init];
    [handler reachabilityCheck];
    RAC(self.submitButton, enabled) = [RACSignal
                                combineLatest:@[ self.item.rac_textSignal, self.code.rac_textSignal, self.colour.rac_textSignal]
                                reduce:^(NSString *itemText, NSString *codeText, NSString *colorText) {
                                    
                                    NSString *itemPattern = @"[A-Z0-9a-z@!&]";
                                    NSString *codePattern = @"[0-9]$";
                                    NSString *colourPattern = @"[A-Za-z@!&]";
                                    
                                    return @([self validateString:itemText withPattern:itemPattern] && [self validateString:codeText withPattern:codePattern] && [self validateString:colorText withPattern:colourPattern]);
                                }];    
}



-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initializeViews];
}



-(void) initializeViews{
    self.item.text=@"";
    self.code.text=@"";
    self.colour.text=@"";
}




- (IBAction)submitAnItem:(id)sender {
    DataHandler* handler = [[DataHandler alloc]init];
    NSString *postString = [NSString stringWithFormat:@"%@/%@/%@/",self.item.text,self.code.text,self.colour.text];
    [handler postRequest:postString];
    [self resignFirstResponder];
}


#pragma mark - Methods to Post

- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}



#pragma mark - TextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.submitButton isEnabled]) {
        [self submitAnItem:self.submitButton];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
