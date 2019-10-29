//
//  OrderStatusViewController.h
//  STLogiPad
//
//  Created by Sreekumar A N on 9/27/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UIButton *backbtn;
}
- (IBAction)BackBtnPressed:(id)sender;

@end
