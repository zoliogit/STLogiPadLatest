//
//  AppDelegate.h
//  STLogiPad
//
//  Created by Sreekumar A N on 8/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHandler.h"
#import "ProductItem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSFileManagerDelegate>
{
    DBHandler *DBhandle;
    
    UIActivityIndicatorView *spinner ;
}

@property DBHandler *DBhandle;
@property (strong, nonatomic) UIWindow *window;
@property NSString *SelProdCode, *userid, *syncDateTime, *warehousecode, *emailaddr, *ccaddr, *ownerCode,*selectedOrderStatus, *imagesynctime;
@property NSMutableArray *prodArray;
@property NSMutableArray *cartArray;
@property NSMutableArray *favArray;
@property ProductItem *SelectedpItem;
@property int currentOrderId,ExcelPAR,SelectedOrderid;
@property NSMutableArray *orderArray, *orderDetailsArray, *SyncprodArray;
@property BOOL islogin,isFromQR,isNeedAlert;
@property (nonatomic, retain) NSMutableArray *customerArray;

-(void)getcustProducts;
-(void)getCSV;

@end

