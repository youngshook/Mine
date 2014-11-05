//
//  ContactsViewController.h
//  Mine
//
//  Created by Pol Quintana on 29/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <REFrostedViewController.h>

@interface ContactsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *contacts;

- (IBAction)showMenu:(UIBarButtonItem *)sender;

@end
