//
//  CustomTwitterCell.h
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-30.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTwitterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end
