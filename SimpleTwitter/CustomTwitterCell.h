//
//  CustomTwitterCell.h
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-30.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CustomTwitterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic)PFObject *tweet;
@end
