//
//  PopOverViewController.m
//  Mine
//
//  Created by Pol Quintana on 04/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "PopOverViewController.h"
#import <Parse/Parse.h>

@interface PopOverViewController ()

@end

@implementation PopOverViewController
#pragma mark - Buttons
- (IBAction)addContactButton:(UIButton *)sender {
    UIAlertView *addContact = [[UIAlertView alloc] initWithTitle:@"Add a Contact" message:@"Type the username of the contact you want to add" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addContact setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addContact show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self addUserRequest:textField.text];
        
    }
}

#pragma mark - Contacts Managing (Parse)
- (void)addUserRequest:(NSString *)userName{
    PFQuery *queryExists = [PFQuery queryWithClassName:@"Relations"];
    [queryExists whereKey:@"username" equalTo:userName];
    [queryExists getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *userError){
        if(!userError){
            PFQuery *query = [PFQuery queryWithClassName:@"Relations"];
            [query whereKey:@"username" equalTo:[PFUser currentUser].username];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                if(!error){
                    NSMutableArray *myRequestsArray = [object objectForKey:@"Requests"];
                    if ([myRequestsArray count] == 0) {
                        myRequestsArray = [[NSMutableArray alloc] initWithObjects:nil, nil];
                    }
                    if(![myRequestsArray containsObject:userName]){
                        [myRequestsArray addObject:userName];
                        NSLog(@"%@", [myRequestsArray description]);
                        [object setObject:myRequestsArray forKey:@"Requests"];
                        [object saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                            if(!error){
                                UIAlertView *requestSent = [[UIAlertView alloc] initWithTitle:@"Request sent" message:[NSString stringWithFormat:@"The request has been sent to %@", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [requestSent show];
                            }
                        }];
                    }
                }
                
            }];
        }
        else{
            UIAlertView *userNotFount = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The user %@ does not exist", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [userNotFount show];
        }
    }];
}



- (void)updateContactToParseUser:(NSString *)userName delete:(BOOL)delete{
    PFQuery *query = [PFQuery queryWithClassName:@"Relations"];
    [query whereKey:@"username" equalTo:userName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error){
        if (!error) {
            NSMutableArray *userArray = [userObject objectForKey:@"Requests"];
            NSUInteger index = [userArray indexOfObject:[PFUser currentUser].username];
            [userArray removeObjectAtIndex:index];
            [userObject setObject:userArray forKey:@"Requests"];
            [userObject saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                if(!error){
                    NSLog(@"Request rejected");
                }
            }];
        }
        
    }];
    if(!delete){
        PFQuery *query2 = [PFQuery queryWithClassName:@"Relations"];
        [query2 whereKey:@"username" equalTo:[PFUser currentUser].username];
        [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *myObject, NSError *error){
            if(!error){
                NSMutableArray *myContactsArray = [myObject objectForKey:@"Contacts"];
                [myContactsArray addObject:userName];
                [myObject setObject:myContactsArray forKey:@"Contacts"];
                [myObject saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                    if(!error){
                        PFQuery *query3 = [PFQuery queryWithClassName:@"Relations"];
                        [query3 whereKey:@"username" equalTo:userName];
                        [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error){
                            if(!error){
                                NSMutableArray *userContactsArray = [userObject objectForKey:@"Contacts"];
                                [userContactsArray addObject:[PFUser currentUser].username];
                                [userObject setObject:userContactsArray forKey:@"Contacts"];
                                [userObject saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                                    if(!error){
                                        UIAlertView *newContact = [[UIAlertView alloc] initWithTitle:@"New User" message:[NSString stringWithFormat:@"%@ is now your friend", userName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [newContact show];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}



#pragma  mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
#warning just to test!!!
    self.requestsArray = @[@"4", @"hola"];
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.requestsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Request Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.requestsArray objectAtIndex:indexPath.row];
    
    cell.
    
    //Add Button
    
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
        [self.requestsArray removeObjectAtIndex:indexPath.row];
      //  [self updateContactToParseUser:user delete:YES];
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
