//
//  HomeTableViewController.m
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-13.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import "HomeTableViewController.h"
#import <Parse/Parse.h>

@interface HomeTableViewController (){
    NSMutableArray *tweets;
}

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=refreshControl;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)refreshTweets{
    [self getTweets];
    [self.refreshControl endRefreshing];
}
- (IBAction)logoutClicked:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getTweets{
    tweets=[[NSMutableArray alloc]init];
    PFQuery *tweetQuery =[PFQuery queryWithClassName:@"Tweet"];
    [tweetQuery includeKey:@"Sender"];
    [tweetQuery orderByDescending:@"createdAt"];
    [tweetQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            for(PFObject *tweet in objects){
                [tweets addObject:tweet];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.tableView reloadData];
                });
            }
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTweets];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell)
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text=[tweets objectAtIndex:indexPath.row][@"Text"];
    PFUser *sender = [tweets objectAtIndex:indexPath.row][@"Sender"];
    cell.detailTextLabel.text=sender.username;
    
    return cell;
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
