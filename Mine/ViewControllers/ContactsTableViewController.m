//
//  ContactsTableViewController.m
//  Mine
//
//  Created by Pol Quintana on 29/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

#pragma mark - ButtonActions
- (IBAction)showMenu:(UIBarButtonItem *)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


#pragma mark - Parse TableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style className:@"Items"];
    if (self) {
        // This table displays items in the Todo class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query includeKey:@"Contacts"];
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.objects count]];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    /*NSString *currentUser = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    NSString *otherUser = [NSString stringWithFormat:@"%@", [object objectForKey:@"User"]];
    NSString *detailText;
    BOOL isEqual = [currentUser isEqualToString:otherUser];
    
    if(isEqual){
        detailText = [NSString stringWithFormat:@"Date: %@",[object objectForKey:@"Date"]];
    }
    else{
        detailText = [NSString stringWithFormat:@"Item from another user: %@ | Date: %@",[object objectForKey:@"User"], [object objectForKey:@"Date"]];
    }*/
    
    NSArray *arrayForContacts = [object objectForKey:@"Contacts"];
    NSLog(@"Count:%lu \n%@", (unsigned long)[arrayForContacts count], arrayForContacts);
    cell.textLabel.text = [arrayForContacts objectAtIndex:indexPath.row];
   // cell.textLabel.text = [object objectForKey:@"Title"];
   // cell.detailTextLabel.text =
    
    return cell;
}

#pragma mark - System

/*-(void)updateUI{
    [self loadObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"User" containedIn:[[PFUser currentUser] objectForKey:@"Contacts"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[objects count]];
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];//Deletes Back button
    //[self askForPermissions];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void) viewWillDisappear:(BOOL)animated {
 if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
 // back button was pressed.  We know this is true because self is no longer
 // in the navigation stack.
 [self updateUI];
 }
 [super viewWillDisappear:animated];
 }
 */

@end
