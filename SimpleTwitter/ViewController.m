//
//  ViewController.m
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-13.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ViewController
- (IBAction)signUpClicked:(id)sender {
    [self.view endEditing:YES];
    PFUser *user=[PFUser user];
    user.username=_usernameField.text;
    user.password=_passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            [self performSegueWithIdentifier:@"showHomeScreen" sender:self];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

    
}

- (IBAction)loginClicked:(id)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error){
        if ( user ) {

            [self performSegueWithIdentifier:@"showHomeScreen" sender:self];
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            _usernameField.text=nil;
            _passwordField.text=nil;
            [_usernameField becomeFirstResponder];
        }
    }];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([PFUser currentUser]){
        [self performSegueWithIdentifier:@"showHomeScreen" sender:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
