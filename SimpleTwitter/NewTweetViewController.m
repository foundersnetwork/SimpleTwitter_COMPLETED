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

@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [tweet saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
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
