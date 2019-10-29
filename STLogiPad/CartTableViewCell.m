//
//  CartTableViewCell.m
//  STLogiPad
//
//  Created by Sreekumar A N on 8/26/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell
@synthesize SLNo,Pimage,Desc,UOM,Qty;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
