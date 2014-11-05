//
//  REMenuTableViewController.m
//  Mine
//
//  Created by Pol Quintana on 26/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "REMenuTableViewController.h"
#import "WallTableViewController.h"
#import "ContactsViewController.h"
#import "UserViewController.h"
#import <UIViewController+REFrostedViewController.h>
#import "RENavigationViewController.h"

@interface REMenuTableViewController ()

@property (nonatomic, strong) UIImageView *imageViewBackup;
@property (nonatomic, strong) NSArray *contactsArray;

@end

@implementation REMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateContacts];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"user"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        self.imageViewBackup = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = [PFUser currentUser].username;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    [self setUserImage];
}

- (void) setUserImage{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error) {
        if (!error) {
            // Found
            PFFile *file = [object objectForKey:@"Image"];
            if (!file) {
                self.imageViewBackup.image = [UIImage imageNamed:@"user"];
            }
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    // image can now be set on a UIImageView
                    self.imageViewBackup.image = image;
                }
            }];

        } else {
            // Did not find for the current user
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error uploading the image. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUserImage];
    [self updateContacts];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"More";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RENavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        WallTableViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
        navigationController.viewControllers = @[homeViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
         ContactsViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
        navigationController.viewControllers = @[secondViewController];
        secondViewController.contacts = [self.contactsArray mutableCopy];
    }
    else if (indexPath.section == 0 && indexPath.row ==2){
        UserViewController *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdController"];
        navigationController.viewControllers = @[thirdViewController];
        
    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

- (void)updateContacts{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error){
        if(!error){
            PFQuery *queryGetContacts = [PFQuery queryWithClassName:@"Relations"];
            [queryGetContacts whereKey:@"username" equalTo:[PFUser currentUser].username];
            [queryGetContacts getFirstObjectInBackgroundWithBlock:^(PFObject *relationsObject, NSError *error){
                if(!error){
                    NSArray *updateArray = [relationsObject objectForKey:@"Contacts"];
                    self.contactsArray = updateArray;
                    [userObject setObject:updateArray forKey:@"Contacts"];
                    [userObject saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                        if(!error){
                            NSLog(@"Updated succesfully");
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Wall", @"Contacts", @"Config"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Help", @"Contact", @"Rate"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
