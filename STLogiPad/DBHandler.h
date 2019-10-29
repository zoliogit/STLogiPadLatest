//
//  DBHandler.h
//  SalesReservation
//
//  Created by Zoliotech on 11/8/16.
//  Copyright © 2016 zoliotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ProductItem.h"


#define DB_NAME @"ST.sqlite"

@interface DBHandler : NSObject
{
    NSString *writableDBPath;
    sqlite3 *database;
}
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)addproductsdetails :(ProductItem*)Proditem;
-(void)adduserdetails :(ProductItem*)Proditem user_id:(NSString*)username;
-(void)getproductsdetails:(NSString*)username;
-(BOOL)addToCart:(ProductItem*)PSelectItem userid:(NSString*)username;
-(void)getcart:(NSString*)username;
-(void)updatecart:(ProductItem*)PSelectItem userid:(NSString*)username;
-(void)deletefromcart:(ProductItem *)PSelectItem userid:(NSString*)username;
-(void)addToFav:(ProductItem*)PSelectItem userid:(NSString*)username;
-(void)getfav:(NSString*)username;
-(void)deletefromfav:(ProductItem *)PSelectItem userid:(NSString*)username;
-(void)sync:(NSString*)username;
-(void)getsynctime:(NSString*)username;
-(void)updateUser_Product:(NSString*)username;
-(void)deleteStatusWithOne:(NSString*)username;
-(void)addOrderStatus:(NSString*)username totalItm:(int)NoOfItem;
-(void)addOrderDetails;
-(void)getOrderstatus:(NSString*)username;
-(void)getOrderdetails:(int)order_id;


@end
