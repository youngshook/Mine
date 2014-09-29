//
//  ContactsViewController.m
//  Mine
//
//  Created by Pol Quintana on 29/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>

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

- (IBAction)addContactButton:(UIBarButtonItem *)sender {
    UIAlertView *addContact = [[UIAlertView alloc] initWithTitle:@"Add a Contact" message:@"Type the username of the contact you want to add" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addContact setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addContact show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self addContactToParseUser:textField.text];
        
    }
}

- (void)addContactToParseUser:(NSString *)userName{    
    PFQuery *queryExists = [PFQuery queryWithClassName:@"_User"];
    [queryExists whereKey:@"username" equalTo:userName];
    [queryExists getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (object) {
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"username" equalTo:[PFUser currentUser].username];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    NSMutableArray *array = [object objectForKey:@"Contacts"];
                    if (![userName isEqualToString:@""]) [array addObject:userName];
                    NSArray *arrayCopy = [array copy];
                    self.contacts = arrayCopy;
                    [object setObject:arrayCopy forKey:@"Contacts"];
                    [object saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                        if (!error) {
                            UIAlertView *contactAdded = [[UIAlertView alloc] initWithTitle:@"Contact Added" message:[NSString stringWithFormat:@"%@ has been added to your contacts", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [contactAdded show];
                            
                            [self.tableView reloadData];
                        }
                    }];
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        }
        else {
            UIAlertView *nothingFound = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The user %@ does not exist", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [nothingFound show];
        }
     
    }];
}



#pragma mark - Parse Query

/*- (void)contactsFromParseToArray{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!error) {
            self.contactsArray = [object valueForKey:@"Contacts"];
        }
    }];
    
}*/

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
