//
//  HomeTableViewController.m
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-13.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import "HomeTableViewController.h"
#import <Parse/Parse.h>
#import "CustomTwitterCell.h"

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
    
    //register the tableview to use the .xib file that we made to load the tableviewcells
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTwitterCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
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
    //get a list of all the people the current user is following
    PFRelation *following=[[PFUser currentUser]relationForKey:@"Following"];
    PFQuery *query=following.query;
    NSMutableArray *peopleFollowing=[[query findObjects]mutableCopy];
    [peopleFollowing addObject:[PFUser currentUser]];   //add yourself to the list so you can see your own tweets
    
    
    PFQuery *tweetQuery =[PFQuery queryWithClassName:@"Tweet"];
    [tweetQuery includeKey:@"Sender"];
    [tweetQuery orderByDescending:@"createdAt"];
    [tweetQuery whereKey:@"Sender" containedIn:peopleFollowing];    //check to see if the sender of the tweet is someone that the current user is following
    [tweetQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            tweets=[objects mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
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
    CustomTwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    // Configure the cell...
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomTwitterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //populate the cells with the data of each tweet
    cell.tweetLabel.text=[tweets objectAtIndex:indexPath.row][@"Text"];
    PFUser *sender = [tweets objectAtIndex:indexPath.row][@"Sender"];
    cell.userLabel.text=sender.username;
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
