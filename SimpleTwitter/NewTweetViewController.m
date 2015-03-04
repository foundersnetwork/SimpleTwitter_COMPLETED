//
//  NewTweetViewController.m
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-13.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import "NewTweetViewController.h"
#import <Parse/Parse.h>

@interface NewTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetField;
@property (weak, nonatomic) IBOutlet UITableView *peopleTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong, nonatomic) NSMutableArray *people;
@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _peopleTable.delegate=self;
    _peopleTable.dataSource=self;
    _searchBar.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendTweet:(id)sender {
    PFObject *tweet = [PFObject objectWithClassName:@"Tweet"];
    tweet[@"Text"]=_tweetField.text;
    tweet[@"Sender"]=[PFUser currentUser];
    tweet[@"NumRetweet"]=@0;
    tweet[@"NumFavorite"]=@0;
    [tweet saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getPeopleWithName:(NSString*)name{
    //search for users with the username that they entered
    self.people=[[NSMutableArray alloc]init];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [query whereKey:@"username" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.people=[objects mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [_peopleTable reloadData];
            });
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.people count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFUser * currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"Following"];
    [relation addObject:[self.people objectAtIndex:indexPath.row]];
    [[PFUser currentUser] saveInBackground];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    // Configure the cell...
    cell.textLabel.text=[self.people objectAtIndex:indexPath.row][@"username"];
    
    return cell;
}


#pragma mark Search Bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=nil;
    [self.view endEditing:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getPeopleWithName:searchBar.text];
    [self.view endEditing:YES];
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomTwitterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.tweetLabel.text=[tweets objectAtIndex:indexPath.row][@"Text"];
//    PFUser *sender = [tweets objectAtIndex:indexPath.row][@"Sender"];
//    cell.userLabel.text=sender.username;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
