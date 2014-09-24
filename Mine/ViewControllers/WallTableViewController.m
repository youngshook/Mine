//
//  WallTableViewController.m
//  Mine
//
//  Created by Pol Quintana on 24/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "WallTableViewController.h"
#import <Parse/Parse.h>

@interface WallTableViewController ()

@end

@implementation WallTableViewController

#pragma mark - ButtonActions

- (IBAction)logOutButton:(UIBarButtonItem *)sender {
    
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
    [query whereKey:@"User" equalTo:[PFUser currentUser].username];
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
        detailText = [NSString stringWithFormat:@"Due Date: %@",[object objectForKey:@"Date"]];
    }
    else{
        detailText = [NSString stringWithFormat:@"Due Date: %@  |  %@",[object objectForKey:@"Date"], [object objectForKey:@"User"]];
    }
    
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];//Deletes Back button
    [self askForPermissions];
}

-(void)updateUI{
    [self loadObjects];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.objects count]];
    NSLog(@"Done: self.objects count: %lu", (unsigned long)[self.objects count]);

}

-(void)askForPermissions{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
