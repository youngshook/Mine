//
//  WallTableViewController.m
//  Mine
//
//  Created by Pol Quintana on 24/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "WallTableViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import <Parse/Parse.h>

@interface WallTableViewController ()

@end

@implementation WallTableViewController

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
        detailText = [NSString stringWithFormat:@"%@",[object objectForKey:@"Date"]];
    }
    else{
        detailText = [NSString stringWithFormat:@"From another user: %@ | %@",[object objectForKey:@"User"], [object objectForKey:@"Date"]];
    }
    
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

#pragma mark - Prepare for Segue

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


#pragma mark - System

-(void)updateUI{
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"User" containedIn:[[PFUser currentUser] objectForKey:@"Contacts"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[objects count]];
            [self clear];
            [self loadObjects];
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    /*PFQuery *query2 = [PFQuery queryWithClassName:@"Items"];
    [query2 whereKey:@"User" containedIn:[[PFUser currentUser] objectForKey:@"Contacts"]];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            self.objects = objects;
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
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

-(void)viewWillAppear:(BOOL)animated{
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
