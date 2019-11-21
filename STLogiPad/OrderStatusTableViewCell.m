//
//  OrderStatusTableViewCell.m
//  STLogiPad
//
//  Created by Sreekumar A N on 9/27/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "OrderStatusTableViewCell.h"

@implementation OrderStatusTableViewCell
@synthesize SlNo,Date,time,NoOfItems,Status;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
