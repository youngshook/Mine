//
//  RERootViewController.m
//  Mine
//
//  Created by Pol Quintana on 26/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "RERootViewController.h"

@interface RERootViewController ()

@end

@implementation RERootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];//Deletes Back button

}

@end

