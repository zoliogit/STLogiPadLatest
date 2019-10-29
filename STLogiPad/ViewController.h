//
//  ViewController.h
//  STLogiPad
//
//  Created by Sreekumar A N on 8/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    __weak IBOutlet UIButton *loginBtn;
}
- (IBAction)LoginPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;



@end

