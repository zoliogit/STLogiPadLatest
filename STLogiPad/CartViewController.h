//
//  CartViewController.h
//  STLogiPad
//
//  Created by Sreekumar A N on 8/25/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListPopOverViewController.h"
#import <MessageUI/MessageUI.h>
#import "ZBarSDK.h"

@interface CartViewController : UIViewController<UIPopoverControllerDelegate,UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,ZBarReaderDelegate,UISearchBarDelegate>
{
    
    __weak IBOutlet UIButton *orderBtn;
    __weak IBOutlet UIButton *scanBtn;
    __weak IBOutlet UIButton *submitBtn;
    __weak IBOutlet UIButton *syncBtn;
    __weak IBOutlet UIButton *loggedBtn;
    __weak IBOutlet UIButton *dateString;
    __weak IBOutlet UIButton *FavCartBtn;
    __weak IBOutlet UIButton *favBtn;
    __weak IBOutlet UITableView *favTable;
    __weak IBOutlet UITableView *cartTable;
    __weak IBOutlet UIButton *productsBtn;
    ProductListPopOverViewController *productListPopOverViewController;
    IBOutlet UITableView *productListTable;
    
    
    
    UIPopoverController *popoverController;
    NSMutableArray *favcartArray;
    NSMutableArray *tempArray;
    BOOL isLogout;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)productsClicked:(id)sender;
- (IBAction)ScnBtnClicked:(id)sender;
- (IBAction)FavbtnClicked:(id)sender;
- (IBAction)SubBtnPressed:(id)sender;
- (IBAction)LogoutBtnPressed:(id)sender;
- (IBAction)OrderBtnPressed:(id)sender;


- (IBAction)FavCartBtnPressed:(id)sender;
- (IBAction)syncBtnClicked:(id)sender;

@end
