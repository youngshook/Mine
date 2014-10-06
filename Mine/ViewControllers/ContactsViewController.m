//
//  ContactsViewController.m
//  Mine
//
//  Created by Pol Quintana on 29/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>
#import <WYPopoverController.h>
#import "PopOverViewController.h"

@interface ContactsViewController () <WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}

@property (nonatomic, strong) NSMutableArray *requestsArray;

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

#pragma mark - Prepare PopOver

- (IBAction)addContactButton:(id)sender {
    
    UIView *button = (UIView *)sender;
    
    PopOverViewController *requestsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Requests"];
    requestsViewController.requestsArray = self.requestsArray;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:requestsViewController];
    contentViewController.viewControllers = @[requestsViewController];
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.delegate = self;
    
    [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

    
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)aPopoverController
{
    return YES;
}

#pragma mark - Update Array

- (void)updateContactToParseUser:(NSString *)userName{
    PFQuery *queryForUserName = [PFQuery queryWithClassName:@"Relations"];
    [queryForUserName whereKey:@"username" equalTo:userName];
    [queryForUserName getFirstObjectInBackgroundWithBlock:^(PFObject *objectFromUser, NSError *errorFromUser){
        if (!errorFromUser) {
            NSMutableArray *arrayFromUser = [objectFromUser objectForKey:@"Contacts"];
            NSUInteger index = [arrayFromUser indexOfObject:[PFUser currentUser].username];
            if(index != 0) [arrayFromUser removeObjectAtIndex:index]; //Prevent from deleting itself
            [objectFromUser setObject:arrayFromUser forKey:@"Contacts"];
            [objectFromUser saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                if (!error) {
                    //Let's delete the user from our contacts array
                    PFQuery *query = [PFQuery queryWithClassName:@"Relations"];
                    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error2){
                        if(!error2){
                            //We have our self.contacts updated
                            [object setObject:self.contacts forKey:@"Contacts"];
                            [object saveInBackgroundWithBlock:^(BOOL succeded3, NSError *error3){
                                if (!error3) {
                                    NSString *title = @"Contact Deleted";
                                    NSString *message = [NSString stringWithFormat:@"%@ has been deleted from your contacts", userName];
                                    UIAlertView *contactAdded = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [contactAdded show];
                                    
                                    [self.tableView reloadData];
                                }
                                else{
                                    UIAlertView *nothingFound = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The user %@ does not exist", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [nothingFound show];
                                }
                            }];
                            
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getRequests];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)getRequests{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"Requests" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                NSString *user = [object objectForKey:@"username"];
                [array addObject:user];
            }
            self.requestsArray = array;
            NSLog(@"%@", [self.requestsArray description]);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.contacts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contacts Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.contacts objectAtIndex:indexPath.row];
 
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *user = cell.textLabel.text;
        [self.contacts removeObjectAtIndex:indexPath.row];
        [self updateContactToParseUser:user];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
