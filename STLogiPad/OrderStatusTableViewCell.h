//
//  OrderStatusTableViewCell.h
//  STLogiPad
//
//  Created by Sreekumar A N on 9/27/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SlNo;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *NoOfItems;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *Status;


@end
