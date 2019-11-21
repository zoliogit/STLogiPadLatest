//
//  ProdDescViewController.h
//  STLogiPad
//
//  Created by Sreekumar A N on 8/25/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdDescViewController : UIViewController
{
   
    
    __weak IBOutlet UIButton *backBtn;
    
    __weak IBOutlet UILabel *Pdesc;
    __weak IBOutlet UIImageView *Pimage;
    
    __weak IBOutlet UILabel *Pcode;
    __weak IBOutlet UILabel *uom;
    __weak IBOutlet UIButton *addBtn;
    
    __weak IBOutlet UIButton *delBtn;
    __weak IBOutlet UIButton *favbtn;
    __weak IBOutlet UILabel *qtyLabel;
    
    BOOL Isdelete;
    
    
}
- (IBAction)PlusPressed:(id)sender;
- (IBAction)MinusPressed:(id)sender;
- (IBAction)AddToCartPressed:(id)sender;
- (IBAction)FavPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)DelBtnPressed:(id)sender;

@end
