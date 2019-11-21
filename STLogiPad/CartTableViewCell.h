//
//  CartTableViewCell.h
//  STLogiPad
//
//  Created by Sreekumar A N on 8/26/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SLNo;
@property (weak, nonatomic) IBOutlet UIImageView *Pimage;
@property (weak, nonatomic) IBOutlet UILabel *Desc;
@property (weak, nonatomic) IBOutlet UILabel *UOM;
@property (weak, nonatomic) IBOutlet UILabel *Qty;
@end
