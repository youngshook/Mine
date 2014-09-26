//
//  ContactsViewController.m
//  Mine
//
//  Created by Pol Quintana on 26/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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

/*- (IBAction)logOutButton:(UIBarButtonItem *)sender {
 
 UIAlertView *logOut = [[UIAlertView alloc]initWithTitle:@"Do you want to Log Out?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Log Out", nil];
 [logOut show];
 
 }
 
 //LogOut Verification
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if (buttonIndex == 1){
 [PFUser logOut];
 [self.navigationController popViewControllerAnimated:YES];
 }
 }
 */

- (IBAction)addItemButton:(UIBarButtonItem *)sender {
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
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    //    [query whereKey:@"User" equalTo:[PFUser currentUser].username];
    [query whereKey:@"User" containedIn:[[PFUser currentUser] objectForKey:@"Contacts"]];
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
    NSString *currentUser = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    NSString *otherUser = [NSString stringWithFormat:@"%@", [object objectForKey:@"User"]];
    NSString *detailText;
    BOOL isEqual = [currentUser isEqualToString:otherUser];
    
    if(isEqual){
        detailText = [NSString stringWithFormat:@"Date: %@",[object objectForKey:@"Date"]];
    }
    else{
        detailText = [NSString stringWithFormat:@"Item from another user: %@ | Date: %@",[object objectForKey:@"User"], [object objectForKey:@"Date"]];
    }
    
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

#pragma mark - Prepare for Segue
/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"Cell Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            DetailViewController *dvc = (DetailViewController *)segue.destinationViewController;
            PFObject *objectAtRow = [self.objects objectAtIndex:[self.tableView indexPathForSelectedRow].row];
            
            dvc.titleForLabel = [objectAtRow objectForKey:@"Title"];
            dvc.dateForLabel = [objectAtRow objectForKey:@"Date"];
            dvc.descriptionForLabel = [objectAtRow objectForKey:@"Description"];
            dvc.userForLabel = [objectAtRow objectForKey:@"User"];
            
        }
    }
    else if ([segue.identifier isEqualToString:@"Add Item"]){
        if ([segue.destinationViewController isKindOfClass:[AddViewController class]]) {
            AddViewController *avc = (AddViewController *)segue.destinationViewController;
            
            avc.updatingObject = NO;
        }
        
    }
}
*/

#pragma mark - System

-(void)updateUI{
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
}

-(void)askForPermissions{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];//Deletes Back button
    [self askForPermissions];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
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
