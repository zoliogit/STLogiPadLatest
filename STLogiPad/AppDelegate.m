//
//  AppDelegate.m
//  STLogiPad
//
//  Created by Sreekumar A N on 8/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductItem.h"
#import "CartViewController.h"
#import "ViewController.h"
#import "customerItem.h"

#define FILE_URL @"http://www.scholartools.com/ios/STH/uploaded_files/"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize SelProdCode,prodArray,cartArray,favArray,DBhandle,userid,SelectedpItem,syncDateTime,currentOrderId,orderArray,orderDetailsArray,islogin,isFromQR,customerArray,warehousecode,emailaddr,ccaddr,SyncprodArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    isFromQR = NO;
    DBhandle=[DBHandler alloc];
    SelectedpItem = [[ProductItem alloc] init];
    [DBhandle createEditableCopyOfDatabaseIfNeeded];
    islogin = NO;
    cartArray = [[NSMutableArray alloc]init];
    favArray = [[NSMutableArray alloc]init];
    orderArray = [[NSMutableArray alloc]init];
    orderDetailsArray = [[NSMutableArray alloc]init];
    
    [self getcustinfo];
     if([[NSUserDefaults standardUserDefaults] objectForKey:@"login"])
     {
         CartViewController *cv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CartViewController"];
         [self.window makeKeyAndVisible];
         [self.window.rootViewController presentViewController:cv animated:YES completion:nil];
     }
     else
     {
         ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
         [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
     }
    
    return YES;
}
-(void)getcustinfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString  *filePath;
    filePath = [NSString stringWithFormat:@"%@/custmr.txt",documentsDirectory];
    if(![fileManager fileExistsAtPath: filePath])
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@custmr.txt",FILE_URL];
        //[NSString stringWithFormat:@"custmr.txt"];
        
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if (urlData)
        {
            [urlData writeToFile:filePath atomically:YES];
        }
    }
    
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *arr = [fileContent componentsSeparatedByString:@"\n"];
        customerArray = [[NSMutableArray alloc] init];
        customerItem *custItem;
        NSMutableArray *whArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [arr count]; i++)
        {
            //--- PUT EACH FIELD SEPARATED BY ',' INTO ARRAY tArr....
            NSArray *tArr = [[arr objectAtIndex:i] componentsSeparatedByString:@","];
            //NSLog(@"displayMainScreen - tArr : %@", tArr);
            
            custItem = [[customerItem alloc] init];
            NSString *tempStr;
            
            //--- FOR EACH FIELD IN EACH customer RECORD
            for (NSInteger j = 0; j < [tArr count]; j++)
            {
                tempStr = [tArr objectAtIndex:j];
                
                //--- REMOVE '"' AND NEW LINES
                NSString *tStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                tStr = [tStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                if (j == 0)
                {
                   // [tDict setValue:tStr forKey:@"OwnerCode"];
                    custItem.ownercode = tStr;//--- OWNER CODE
                }
                else if (j == 1)
                {
                  //  [tDict setValue:tStr forKey:@"WarehouseCode"];      //--- WAREHOUSE CODE
                    custItem.warehousecode = tStr;
                    
                    BOOL found = NO;
                    
                    for (NSInteger k = 0; k < [whArray count]; k++)
                    {
                        if ([[whArray objectAtIndex:k] isEqual:tStr])
                            found = YES;
                    }
                    
                    //--- ADD NEW WarehouseCode to ARRAY OF WAREHOUSE CODES....
                    if (found == NO)
                        [whArray addObject:tStr];
                }
                else if (j == 2)
                             //--- CUSTOMER CODE
                custItem.CustCode = tStr;
                else if (j == 3)
                {
                    custItem.EmailAddr = tStr;         //--- EMAIL ADDRESS
                }
                else if (j == 4)
                {
                    custItem.CcAddr = tStr;         //--- EMAIL ADDRESS
                }
                else if (j == 5)
                {
                    //--- REMOVE NEW LINE (\r OR \n?)....
                    tStr = [tStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    custItem.AuthCode = tStr;
                }
                else if (j == 6)
                {
                    //--- REMOVE NEW LINE (\r OR \n?)....
                    tStr = [tStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    custItem.UDIDNo = tStr;
                }
            }
            
            
            [customerArray addObject:custItem];
    }
    
   
}
-(void)getcustProducts
{
    // [DBhandle updateUser_Product:userid];
    
    [DBhandle updateUser_Product];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString  *filePath;
    filePath = [NSString stringWithFormat:@"%@/%@-Invntry.txt",documentsDirectory,warehousecode];
    if(![fileManager fileExistsAtPath: filePath])
    {
        NSString *stringURL =[NSString stringWithFormat:@"%@%@-Invntry.txt",FILE_URL,warehousecode];
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
         if (urlData)
         {
              [urlData writeToFile:filePath atomically:YES];
         }
        
        //--- READ CONTENT FROM customer.txt in Documents DIRECTORY....
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *arr = [fileContent componentsSeparatedByString:@"\n"];
        
        NSLog(@"arr : %@", arr);
        NSMutableArray *tArray = [[NSMutableArray alloc] init];
        
        ProductItem *pitem = [[ProductItem alloc] init];
        
        for (NSInteger i = 0; i < [arr count]; i++)
        {
            NSArray *tArr = [[arr objectAtIndex:i] componentsSeparatedByString:@"|"];
            NSLog(@"tArr :%@",tArr);
            pitem = [[ProductItem alloc] init];
            NSString *tempStr;
            for (NSInteger j = 0; j < [tArr count]; j++)
            {
                tempStr = [tArr objectAtIndex:j];
                NSString *tStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                tStr = [tStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSLog(@"tStr :%@",tStr);
                if (j == 0)
                {
                    NSLog(@"j == 0 ->>> %@", tStr);
                    pitem.ownercode = tStr;
                    
                }
                else if (j == 1)
                {
                    pitem.warehousecode = tStr;
                    //[tDict setValue:tStr forKey:@"WarehouseCode"];
                }
                else if (j == 2)
                {
                    pitem.productcode = tStr;
                    
                    //[tDict setValue:tStr forKey:@"ProductCode"];
                }
                else if (j == 3)
                {
                    pitem.proddescription = tStr;
                    // [tDict setValue:tStr forKey:@"ProductDesc"];
                }
                else if (j == 4)
                {
                    pitem.StdPackDet = tStr;
                    NSLog(@"StdPackDet ->>> %@", tStr);
                    //  [tDict setValue:tStr forKey:@"StdPackDet"];
                }
                else if (j == 5)
                {
                    pitem.productuom = tStr;
                    NSLog(@"ProductUOM ->>> %@", tStr);
                    
                    // [tDict setValue:tStr forKey:@"ProductUOM"];
                }
                else if (j == 6)
                {
                    // 2018
                    tStr = [tStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    tStr = [tStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSLog(@"QuantityAvail ->>> %@", tStr);
                    pitem.quantity = [tStr intValue];
                    //[tDict setValue:tStr forKey:@"QuantityAvail"];
                }
                
            }
            if(pitem.productcode != NULL)
                [tArray addObject:pitem];
        }
        
        for(int i=0;i<tArray.count;i++)
        {
            ProductItem *item =[[ProductItem alloc]init];
            item = [tArray objectAtIndex:i];
            //[DBhandle adduserdetails:item user_id:userid];
            [DBhandle adduserdetails:item];
            [DBhandle addproductsdetails:item];
        }
        //[DBhandle deleteStatusWithOne:userid];
        
        [DBhandle deleteStatusWithOne];
        [DBhandle sync];
        [DBhandle getsynctime];
       // [DBhandle sync:userid];
       // [DBhandle getsynctime:userid];
        [[NSUserDefaults standardUserDefaults] setValue:syncDateTime forKey:@"datetime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     else //file exists in file path
         
     {
        userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
         warehousecode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"warehousecode"];
        syncDateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"datetime"];
     }
   
    
   
    
  
   
    

    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
