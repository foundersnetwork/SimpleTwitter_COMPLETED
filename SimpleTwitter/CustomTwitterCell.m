//
//  CustomTwitterCell.m
//  SimpleTwitter
//
//  Created by Mark Hall on 2015-01-30.
//  Copyright (c) 2015 Mark Hall. All rights reserved.
//

#import "CustomTwitterCell.h"

@implementation CustomTwitterCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.favoriteButton.selected=NO;
    self.retweetButton.selected=NO;
}
-(void)setTweet:(PFObject *)tweet{
    _tweet=tweet;
    //populate the cells with the data of each tweet
    self.tweetLabel.text=_tweet[@"Text"];
    self.retweetCount.text=[NSString stringWithFormat:@"%@",_tweet[@"NumRetweet"]];
    self.favoriteCount.text=[NSString stringWithFormat:@"%@",_tweet[@"NumFavorite"]];;
    PFUser *sender = _tweet[@"Sender"];
    self.userLabel.text=sender.username;
    
    
    if([sender.objectId isEqualToString:[PFUser currentUser].objectId]){
        self.favoriteButton.enabled=NO;
        self.retweetButton.enabled=NO;
    }
    else{
        self.favoriteButton.enabled=YES;
        self.retweetButton.enabled=YES;
    }
    
}
- (IBAction)favoritePressed:(UIButton *)sender {
    sender.selected=!sender.selected;
    [_tweet incrementKey:@"NumFavorite"];
    [_tweet saveInBackground];
}
- (IBAction)retweetPressed:(UIButton *)sender {
    sender.selected=!sender.selected;
    [_tweet incrementKey:@"NumRetweet"];
    [_tweet saveInBackground];
    
    PFObject *newTweet=[PFObject objectWithClassName:@"Tweet"];
    newTweet[@"Text"]=_tweet[@"Text"];
    newTweet[@"Sender"]=[PFUser currentUser];
    newTweet[@"NumRetweet"]=@0;
    newTweet[@"NumFavorite"]=@0;
    [newTweet saveInBackground];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
