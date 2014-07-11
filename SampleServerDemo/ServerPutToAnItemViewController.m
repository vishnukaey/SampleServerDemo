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
	// Do any additional setup after loading the view.
}
- (IBAction)editAnItem:(id)sender {
    PFQuery *query=[PFQuery queryWithClassName:@"WebService"];
    [query whereKey:@"Item" notEqualTo:@""];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        bool isPresent=NO;
        for (int i=0; i < array.count; i++){
            if([[[array objectAtIndex:i] valueForKey:@"Item"] isEqualToString:self.item.text] ||
               [[[array objectAtIndex:i] valueForKey:@"Code"] isEqualToString:self.code.text] ||
               [[[array objectAtIndex:i] valueForKey:@"Colour"] isEqualToString:self.colour.text]){
                [self setObject];
                [[array objectAtIndex:i] setObject:self.item.text forKey:@"Item"];
                [[array objectAtIndex:i] setObject:self.code.text forKey:@"Code"];
                [[array objectAtIndex:i] setObject:self.colour.text forKey:@"Colour"];
                isPresent=YES;
                [[array objectAtIndex:i] saveInBackground];
            }
        }
        if(!isPresent){
            [self addObject];
        }
    }];

    }

-(void) addObject{
    PFObject *items=[PFObject objectWithClassName:@"WebService"];
    items[@"Item"]=self.item.text;
    items[@"Code"]=self.code.text;
    items[@"Colour"]=self.colour.text;
    [items saveInBackground];
}

-(void) setObject{
    
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
