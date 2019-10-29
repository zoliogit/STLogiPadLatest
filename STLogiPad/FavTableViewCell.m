//
//  FavTableViewCell.m
//  STLogiPad
//
//  Created by Sreekumar A N on 9/28/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "FavTableViewCell.h"

@implementation FavTableViewCell
@synthesize productDesc,CheckBxBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
