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
     NSString *ftpFromType;
    __weak IBOutlet UIButton *loginBtn;
}

@property (nonatomic, retain)   NSOutputStream *  networkStream;
@property (nonatomic, retain)   NSInputStream *   fileStream;

- (IBAction)LoginPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *buildNo;



@end

