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


//Changed ones
//-(void)adduserdetails :(ProductItem*)Proditem user_id:(NSString*)username;
//-(void)deleteStatusWithOne:(NSString*)username;
//-(void)updateUser_Product:(NSString*)username;
//-(void)sync:(NSString*)username;
//-(void)getsynctime:(NSString*)username;
//-(void)getproductsdetails:(NSString*)username;

//Newones
-(void)adduserdetails :(ProductItem*)Proditem;
-(void)deleteStatusWithOne;
-(void)updateUser_Product;
-(void)sync;
-(void)getsynctime;
-(void)getproductsdetails;


-(BOOL)addToCart:(ProductItem*)PSelectItem userid:(NSString*)username;
-(void)getcart:(NSString*)username;
-(void)updatecart:(ProductItem*)PSelectItem userid:(NSString*)username;
-(void)deletefromcart:(ProductItem *)PSelectItem userid:(NSString*)username;
-(BOOL)addToFav:(ProductItem*)PSelectItem userid:(NSString*)username pr:(int)par;

-(void)getfav:(NSString*)username;
-(void)deletefromfav:(ProductItem *)PSelectItem userid:(NSString*)username;

-(void)imagesync;
-(void)getimagesynctime;

-(void)addOrderStatus:(NSString*)username totalItm:(int)NoOfItem sts:(NSString*)Status;
-(void)addOrderDetails;
-(void)getOrderstatus:(NSString*)username;
-(void)getOrderdetails:(int)order_id;

-(void)addCSVValues :(NSString*)Prodid loc:(NSString*)location par:(int)PAR;
-(void)deletecsvValues;
-(void)getExcelPAR:(NSString*)username pid:(NSString*)prodid;

-(void)deleteOrderstatus_detailsWithStatusPending:(int)orderId;
-(void)addOrderDetailsFromPendingStatus;
@end
