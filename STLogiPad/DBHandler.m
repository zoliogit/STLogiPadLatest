//
//  DBHandler.m
//  SalesReservation
//
//  Created by Zoliotech on 11/8/16.
//  Copyright © 2016 zoliotech. All rights reserved.
//

#import "DBHandler.h"
#import "AppDelegate.h"



@implementation DBHandler

-(void)createEditableCopyOfDatabaseIfNeeded {
    
    // First, test for existence.
    
    BOOL successCreation;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    successCreation = [fileManager fileExistsAtPath:writableDBPath];
    if (successCreation) {
        
        //  NSLog(@"Initialized");
        if( sqlite3_open([writableDBPath UTF8String],&database)==SQLITE_OK)
            //NSLog(@"opened");
            
            NSLog(@"writableDBPath:%@",writableDBPath);
        return;
    }
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    successCreation = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!successCreation) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    else{
        if( sqlite3_open([writableDBPath UTF8String],&database)==SQLITE_OK)
            NSLog(@"opened");
        NSLog(@"%@", writableDBPath);     
    }
}

-(void)updateUser_Product
{
    sqlite3_stmt *updateStmt,*updateStmt1;
    NSString *querySQLupdate = [NSString stringWithFormat:@"UPDATE products SET status = %d",1];
    NSLog(@"query %@",querySQLupdate);
    const char *query_stmt_update= [querySQLupdate UTF8String];
    
    if (sqlite3_prepare_v2(database, query_stmt_update, -1, &updateStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"UPDATE sqlite3_errmsg --- %s", sqlite3_errmsg(database));
    }
    if(SQLITE_DONE != sqlite3_step(updateStmt))
    {
        NSLog(@"UPDATE error message %s",sqlite3_errmsg(database));
    }
    sqlite3_reset(updateStmt);
    
    NSString *querySQLupdate1 = [NSString stringWithFormat:@"UPDATE products_details SET status = %d",1];
    NSLog(@"query %@",querySQLupdate1);
    const char *query_stmt_update1= [querySQLupdate1 UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_update1, -1, &updateStmt1, NULL) != SQLITE_OK)
    {
        NSLog(@"UPDATE sqlite3_errmsg --- %s", sqlite3_errmsg(database));
    }
    if(SQLITE_DONE != sqlite3_step(updateStmt1))
    {
        NSLog(@"UPDATE error message %s",sqlite3_errmsg(database));
    }
    sqlite3_reset(updateStmt1);
}

//-(void)updateUser_Product:(NSString*)username
//{
//    sqlite3_stmt *updateStmt,*updateStmt1;
//    NSString *querySQLupdate = [NSString stringWithFormat:@"UPDATE products SET status = %d where user_id = '%@'",1,username];
//    NSLog(@"query %@",querySQLupdate);
//    const char *query_stmt_update= [querySQLupdate UTF8String];
//
//    if (sqlite3_prepare_v2(database, query_stmt_update, -1, &updateStmt, NULL) != SQLITE_OK)
//    {
//        NSLog(@"UPDATE sqlite3_errmsg --- %s", sqlite3_errmsg(database));
//    }
//    if(SQLITE_DONE != sqlite3_step(updateStmt))
//    {
//        NSLog(@"UPDATE error message %s",sqlite3_errmsg(database));
//    }
//    sqlite3_reset(updateStmt);
//
//    NSString *querySQLupdate1 = [NSString stringWithFormat:@"UPDATE products_details SET status = %d WHERE products_id IN (SELECT a.products_id FROM products a WHERE user_id = '%@')",1,username];
//    NSLog(@"query %@",querySQLupdate1);
//    const char *query_stmt_update1= [querySQLupdate1 UTF8String];
//    if (sqlite3_prepare_v2(database, query_stmt_update1, -1, &updateStmt1, NULL) != SQLITE_OK)
//    {
//        NSLog(@"UPDATE sqlite3_errmsg --- %s", sqlite3_errmsg(database));
//    }
//    if(SQLITE_DONE != sqlite3_step(updateStmt1))
//    {
//        NSLog(@"UPDATE error message %s",sqlite3_errmsg(database));
//    }
//    sqlite3_reset(updateStmt1);
//}

-(void)adduserdetails :(ProductItem*)Proditem
{
    sqlite3_stmt *InsertStmt;
    
    
    
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO products(products_id,status) VALUES(?,?)"];
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_text(InsertStmt, 1, [Proditem.productcode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 2, 0);
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    else
    {
        
        NSLog(@"user details saved");
        
    }
    sqlite3_finalize(InsertStmt);
}

//-(void)adduserdetails :(ProductItem*)Proditem user_id:(NSString*)username
//{
//    sqlite3_stmt *InsertStmt;
//
//    //,*selectStmt;
//   // const char *query_stmt_Select;
//   // BOOL isAlready = 0;
////    NSString *querySelect = [NSString stringWithFormat:@"select * from products where products_id = '%@' and user_id = '%@'",[ProdDetailsdict objectForKey:@"ProductCode"],username];
////    query_stmt_Select = [querySelect UTF8String];
////    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
////    {
////        while (sqlite3_step(selectStmt) == SQLITE_ROW)
////        {
////
////            isAlready = 1;
////            NSLog(@"isAlready :%d",isAlready);
////        }
////    }
////    if(!isAlready)
////    {
//
//    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO products(products_id,user_id,status) VALUES(?,?,?)"];
//    const char *query_stmt_Insert= [querySQLInsert UTF8String];
//
//    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
//        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
//    else
//    {
//        sqlite3_bind_text(InsertStmt, 1, [Proditem.productcode UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(InsertStmt, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int(InsertStmt, 3, 0);
//    }
//    if(SQLITE_DONE != sqlite3_step(InsertStmt))
//        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
//    else
//    {
//
//        NSLog(@"user details saved");
//
//    }
//    sqlite3_finalize(InsertStmt);
//
//    //}
//
//}
//-(void)sync:(NSString*)username
//{
//    sqlite3_stmt *InsertStmt;
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO sync(user_id,sync_datetime) VALUES(?,?)"];
//    const char *query_stmt_Insert= [querySQLInsert UTF8String];
//    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
//        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
//    else
//    {
//        sqlite3_bind_text(InsertStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(InsertStmt, 2, [dateString UTF8String], -1, SQLITE_TRANSIENT);
//    }
//    if(SQLITE_DONE != sqlite3_step(InsertStmt))
//        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
//    else
//    {
//
//        NSLog(@"sync details saved");
//
//    }
//    sqlite3_finalize(InsertStmt);
//}

-(void)sync
{
    sqlite3_stmt *DeleteStmt;
    NSString *querySQLDelete =  @"";
    const char *query_stmt_Delete;
    querySQLDelete = [NSString stringWithFormat:@"delete from sync"];
    
    query_stmt_Delete= [querySQLDelete UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt);
    sqlite3_stmt *InsertStmt;
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO sync(sync_datetime) VALUES(datetime('now', 'localtime'))"];
    NSLog(@"querySQLInsert:%@",querySQLInsert);
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
       
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    else
    {
        
        NSLog(@"sync details saved");
        
    }
    sqlite3_finalize(InsertStmt);
}
-(void)getsynctime
{
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *querySelect = [NSString stringWithFormat:@"SELECT sync_datetime from sync"];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            thisApp.syncDateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
        }
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate =[dateFormatter dateFromString:thisApp.syncDateTime];
    
    dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mma"];
    thisApp.syncDateTime = [dateFormatter stringFromDate:myDate];
    
    
    NSLog(@"Timmeee  ::::::::::%@",thisApp.syncDateTime);
}
//-(void)getsynctime:(NSString*)username
//{
//    sqlite3_stmt *selectStmt;
//    const char *query_stmt_Select;
//    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *querySelect = [NSString stringWithFormat:@"SELECT sync_datetime from sync where user_id = '%@'",username];
//    query_stmt_Select = [querySelect UTF8String];
//    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
//    {
//        while (sqlite3_step(selectStmt) == SQLITE_ROW)
//        {
//            thisApp.syncDateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
//        }
//    }
//}
-(void)deletefromfav:(ProductItem *)PSelectItem userid:(NSString*)username
{
    sqlite3_stmt *DeleteStmt;
    NSString *querySQLDelete =  @"";
    const char *query_stmt_Delete;
    querySQLDelete = [NSString stringWithFormat:@"delete from favourites where user_id = '%@' and products_id = '%@'",username,PSelectItem.productcode];
    
    query_stmt_Delete= [querySQLDelete UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt);
}
-(void)deletefromcart:(ProductItem *)PSelectItem userid:(NSString*)username
{
    sqlite3_stmt *DeleteStmt;
    NSString *querySQLDelete =  @"";
    const char *query_stmt_Delete;
    querySQLDelete = [NSString stringWithFormat:@"delete from cart where user_id = '%@' and products_id = '%@'",username,PSelectItem.productcode];
    
    query_stmt_Delete= [querySQLDelete UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt);
}
-(void)updatecart:(ProductItem*)PSelectItem userid:(NSString*)username
{
    sqlite3_stmt *updateStmt;
    NSString *querySQLupdate = [NSString stringWithFormat:@"UPDATE cart SET cart_qty = %d where user_id = '%@' and products_id = '%@'",PSelectItem.quantity,username,PSelectItem.productcode];
    NSLog(@"query %@",querySQLupdate);
    const char *query_stmt_update= [querySQLupdate UTF8String];
    
    if (sqlite3_prepare_v2(database, query_stmt_update, -1, &updateStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"UPDATE sqlite3_errmsg --- %s", sqlite3_errmsg(database));
    }
    if(SQLITE_DONE != sqlite3_step(updateStmt))
    {
        NSLog(@"UPDATE error message %s",sqlite3_errmsg(database));
    }
    sqlite3_reset(updateStmt);
}
-(void)getcart:(NSString*)username
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
   thisApp.cartArray = [[NSMutableArray alloc] init];
    NSString *querySelect = [NSString stringWithFormat:@"SELECT a.products_desc,a.products_uom,b.cart_qty,b.products_id from products_details a ,cart b WHERE a.products_id = b.products_id AND b.user_id = '%@'",username];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem.proddescription = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
            pitem.productuom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
            pitem.quantity = sqlite3_column_int(selectStmt, 2);
             pitem.productcode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,3)];
            [thisApp.cartArray addObject:pitem];
        }
    }
}
-(void)getfav:(NSString*)username
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    thisApp.favArray = [[NSMutableArray alloc] init];
    NSString *querySelect = [NSString stringWithFormat:@"SELECT a.products_desc,a.products_uom,a.products_qty,a.products_id from products_details a ,favourites b WHERE a.products_id = b.products_id AND b.user_id = '%@' ORDER BY a.products_desc ASC",username];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem.proddescription = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
            pitem.productuom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
            pitem.quantity = sqlite3_column_int(selectStmt, 2);
            pitem.productcode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,3)];
            [thisApp.favArray addObject:pitem];
        }
    }
}

-(BOOL)addToFav:(ProductItem*)PSelectItem userid:(NSString*)username
{
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    BOOL isAlready = 0;
    NSString *querySelect = [NSString stringWithFormat:@"select * from favourites where products_id = '%@' and user_id = '%@'",PSelectItem.productcode,username];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            
            isAlready = 1;
            NSLog(@"isAlready :%d",isAlready);
        }
    }
    if(!isAlready)
    {
    sqlite3_stmt *InsertStmt;
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO favourites(products_id,user_id) VALUES(?,?)"];
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_text(InsertStmt, 1, [PSelectItem.productcode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
        
        
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    else
    {
        
        NSLog(@"fav details saved");
        
    }
    
    sqlite3_finalize(InsertStmt);
    }
    
    return isAlready;
}
-(BOOL)addToCart:(ProductItem*)PSelectItem userid:(NSString*)username
{
    BOOL isaddedtocart = 0;
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    BOOL isAlready = 0;
    NSString *querySelect = [NSString stringWithFormat:@"select * from cart where products_id = '%@' and user_id = '%@'",PSelectItem.productcode,username];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            
            isAlready = 1;
            NSLog(@"isAlready :%d",isAlready);
        }
    }
    if(!isAlready)
    {
    
    sqlite3_stmt *InsertStmt;
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO cart(products_id,user_id,cart_qty) VALUES(?,?,?)"];
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_text(InsertStmt, 1, [PSelectItem.productcode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 3, PSelectItem.quantity);
       
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    else
    {
        isaddedtocart = 1;
        NSLog(@"cart details saved");
        
    }
    sqlite3_finalize(InsertStmt);
    }
    return isaddedtocart;
}
-(void)getOrderdetails:(int)order_id
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    ProductItem *pitem ;
    NSString *querySelect = [NSString stringWithFormat:@"SELECT  b.products_id,b.products_desc,b.products_uom,b.products_qty FROM order_details b WHERE  b.order_id = %d",order_id];
    NSLog(@"queryselect :%@",querySelect);
    query_stmt_Select = [querySelect UTF8String];
    thisApp.orderDetailsArray = [[NSMutableArray alloc]init];
    
    
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            
            pitem  = [[ProductItem alloc] init];
            
           pitem.productcode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
            
            pitem.proddescription = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
            
            pitem.productuom =[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,2)];
           pitem.quantity =  sqlite3_column_int(selectStmt, 3);
         [thisApp.orderDetailsArray addObject:pitem];
            
        }
        
        NSLog(@"orderarray %@",thisApp.orderDetailsArray);
    }
}
-(void)getOrderstatus:(NSString*)username
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
   
    NSString *querySelect = [NSString stringWithFormat:@"SELECT  a.totalItems,a.date_time,a.status_order,a.order_id FROM order_status a WHERE user_id = '%@'",username];
//                             ,b.products_id,b.products_desc,b.products_uom,b.products_qty FROM order_status a ,order_details b WHERE user_id = '%@' and a.order_id = b.order_id",username];
    
    thisApp.orderArray = [[NSMutableArray alloc]init];
    NSLog(@"queryselect :%@",querySelect);
    query_stmt_Select = [querySelect UTF8String];
    NSMutableDictionary *dict;
        if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
           
            dict = [[NSMutableDictionary alloc] init];
            int ItemsCount =  sqlite3_column_int(selectStmt, 0);
            
            NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
           
           NSString *status = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,2)];
            
            NSString *orderid =[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,3)];
            
            
            
            [dict setObject:[NSString stringWithFormat:@"%d", ItemsCount] forKey:@"itemcount"];
            [dict setObject:date forKey:@"date"];
            [dict setObject:status forKey:@"status"];
            [dict setObject:orderid forKey:@"orderid"];
            [thisApp.orderArray addObject:dict];
            
        }
        
        NSLog(@"orderarray %@",thisApp.orderArray);
    }
}
-(void)addOrderDetails
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *InsertStmt = NULL;
    ProductItem *pitem  = [[ProductItem alloc]init];
    for(int i=0 ; i<thisApp.cartArray.count;i++)
    {
    pitem = [thisApp.cartArray objectAtIndex:i];
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO order_details(order_id,products_id,products_desc,products_uom,products_qty) VALUES(?,?,?,?,?)"];
        NSLog(@"querySQLInsert :%@",querySQLInsert);
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_int(InsertStmt, 1, thisApp.currentOrderId);
        sqlite3_bind_text(InsertStmt, 2, [pitem.productcode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 3, [pitem.proddescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 4, [pitem.productuom UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 5, pitem.quantity);
    }
        if(SQLITE_DONE != sqlite3_step(InsertStmt))
        {
            NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
        }
        else
        {
            
            NSLog(@"Order status details saved");
            
        }
        
    }
    sqlite3_finalize(InsertStmt);
}
-(void)addOrderStatus:(NSString*)username totalItm:(int)NoOfItem
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sqlite3_stmt *InsertStmt;
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mma"];
   
    
    
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"dateString:%@",dateString);
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO order_status(user_id,totalItems,date_time,status_order) VALUES(?,?,?,?)"];
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_text(InsertStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 2, NoOfItem);
        sqlite3_bind_text(InsertStmt, 3, [dateString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 4, [[NSString stringWithFormat:@"Submitted"] UTF8String], -1, SQLITE_TRANSIENT);
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
    {
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        thisApp.currentOrderId = sqlite3_last_insert_rowid(database);
        NSLog(@"Order status details saved :%d",thisApp.currentOrderId);
        
    }
    sqlite3_finalize(InsertStmt);
}
-(void)addproductsdetails :(ProductItem*)Proditem;
{
    sqlite3_stmt *DeleteStmt;
    NSString *querySQLDelete =  @"";
    const char *query_stmt_Delete;
    querySQLDelete = [NSString stringWithFormat:@"delete from products_details WHERE products_id = '%@'",Proditem.productcode];
    
    query_stmt_Delete= [querySQLDelete UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt);
    
    
    sqlite3_stmt *InsertStmt;
    NSString *querySQLInsert = [NSString stringWithFormat:@"INSERT INTO products_details(products_id,products_desc,products_qty,products_uom,status) VALUES(?,?,?,?,?)"];
    const char *query_stmt_Insert= [querySQLInsert UTF8String];
    if(sqlite3_prepare_v2(database, query_stmt_Insert, -1, &InsertStmt, NULL)!= SQLITE_OK)
        NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    else
    {
        sqlite3_bind_text(InsertStmt, 1, [Proditem.productcode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(InsertStmt, 2, [Proditem.proddescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 3, Proditem.quantity );
        sqlite3_bind_text(InsertStmt, 4, [Proditem.productuom UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(InsertStmt, 5, 0);
    }
    if(SQLITE_DONE != sqlite3_step(InsertStmt))
    {
        NSLog(@"Error while inserting result data. '%s'", sqlite3_errmsg(database));
    }
    else
    {
       
        NSLog(@"product details saved: %@",Proditem.productcode);
        
    }
    sqlite3_finalize(InsertStmt);
}
-(void)deleteStatusWithOne
{
    sqlite3_stmt *DeleteStmt;
    NSString *querySQLDelete =  @"";
    const char *query_stmt_Delete;
    querySQLDelete = [NSString stringWithFormat:@"delete from products where status = %d",1];
    
    query_stmt_Delete= [querySQLDelete UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt);
    
    sqlite3_stmt *DeleteStmt1;
    NSString *querySQLDelete1 =  @"";
    const char *query_stmt_Delete1;
    querySQLDelete1 = [NSString stringWithFormat:@"delete from products_details where status = %d",1];
    
    query_stmt_Delete1= [querySQLDelete1 UTF8String];
    if( sqlite3_prepare_v2(database,query_stmt_Delete1, -1, &DeleteStmt1, NULL) == SQLITE_OK )
    {
        sqlite3_step(DeleteStmt1);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(DeleteStmt1);
}

//-(void)deleteStatusWithOne:(NSString*)username
//{
//    sqlite3_stmt *DeleteStmt;
//    NSString *querySQLDelete =  @"";
//    const char *query_stmt_Delete;
//    querySQLDelete = [NSString stringWithFormat:@"delete from products where user_id = '%@' and status = %d",username,1];
//
//    query_stmt_Delete= [querySQLDelete UTF8String];
//    if( sqlite3_prepare_v2(database,query_stmt_Delete, -1, &DeleteStmt, NULL) == SQLITE_OK )
//    {
//        sqlite3_step(DeleteStmt);
//    }
//    else
//    {
//        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
//    }
//    sqlite3_finalize(DeleteStmt);
//
//    sqlite3_stmt *DeleteStmt1;
//    NSString *querySQLDelete1 =  @"";
//    const char *query_stmt_Delete1;
//    querySQLDelete1 = [NSString stringWithFormat:@"delete from products_details where status = %d",1];
//
//    query_stmt_Delete1= [querySQLDelete1 UTF8String];
//    if( sqlite3_prepare_v2(database,query_stmt_Delete1, -1, &DeleteStmt1, NULL) == SQLITE_OK )
//    {
//        sqlite3_step(DeleteStmt1);
//    }
//    else
//    {
//        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
//    }
//    sqlite3_finalize(DeleteStmt1);
//}
-(void)getproductsdetails
{
    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    thisApp.prodArray = [[NSMutableArray alloc]init];
    sqlite3_stmt *selectStmt;
    const char *query_stmt_Select;
    NSString *querySelect = [NSString stringWithFormat:@"select * FROM products_details ORDER BY products_desc ASC"];
    query_stmt_Select = [querySelect UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem.productcode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
            pitem.proddescription = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
            pitem.quantity = sqlite3_column_int(selectStmt, 2);
            pitem.productuom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,3)];
            [thisApp.prodArray addObject:pitem];
            
        }
    }
}
//-(void)getproductsdetails:(NSString*)username
//{
//    AppDelegate *thisApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    thisApp.prodArray = [[NSMutableArray alloc]init];
//    sqlite3_stmt *selectStmt;
//    const char *query_stmt_Select;
//    NSString *querySelect = [NSString stringWithFormat:@"select * FROM products_details WHERE products_id IN (SELECT a.products_id FROM products a WHERE a.user_id = '%@')",username];
//    query_stmt_Select = [querySelect UTF8String];
//    if (sqlite3_prepare_v2(database, query_stmt_Select, -1, &selectStmt, NULL) == SQLITE_OK)
//    {
//        while (sqlite3_step(selectStmt) == SQLITE_ROW)
//        {
//            ProductItem *pitem = [[ProductItem alloc] init];
//             pitem.productcode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
//             pitem.proddescription = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,1)];
//           pitem.quantity = sqlite3_column_int(selectStmt, 2);
//            pitem.productuom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,3)];
//            [thisApp.prodArray addObject:pitem];
//
//        }
//    }
//}

@end
