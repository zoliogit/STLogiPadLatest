//
//  orderDetailsViewController.h
//  STLogiPad
//
//  Created by Sreekumar A N on 10/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailsViewController : UIViewController
{
    
    __weak IBOutlet UIButton *dateTime;
    __weak IBOutlet UIButton *ReorderBtn;
    __weak IBOutlet UIButton *backBtn;
}
@property NSString* dateTimeString;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)ReorderBtnPressed:(id)sender;

@end
