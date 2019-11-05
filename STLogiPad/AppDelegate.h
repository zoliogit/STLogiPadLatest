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

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DBHandler *DBhandle;
}

@property DBHandler *DBhandle;
@property (strong, nonatomic) UIWindow *window;
@property NSString *SelProdCode, *userid, *syncDateTime;
@property NSMutableArray *prodArray;
@property NSMutableArray *cartArray;
@property NSMutableArray *favArray;
@property ProductItem *SelectedpItem;
@property int currentOrderId;
@property NSMutableArray *orderArray, *orderDetailsArray;
@property BOOL islogin,isFromQR;

-(void)getcustProducts;

@end

