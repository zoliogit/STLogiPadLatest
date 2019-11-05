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

#define FILE_URL @"http://www.scholartools.com/ios/STH/uploaded_files/"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize SelProdCode,prodArray,cartArray,favArray,DBhandle,userid,SelectedpItem,syncDateTime,currentOrderId,orderArray,orderDetailsArray,islogin,isFromQR;

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
    
//    NSMutableDictionary *prodDict1 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict2 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict3 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict4 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict5 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict6 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict7 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict8 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict9 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *prodDict10 = [[NSMutableDictionary alloc]init];
//    
//    [prodDict1 setValue:@"118007016" forKey:@"ProductCode"];//001140030
//    [prodDict1 setValue:@"SODIUM CHLORIDE  0.9% FOR IRRIGATION 1L" forKey:@"ProductDesc"];
//    [prodDict1 setValue:@"BT" forKey:@"ProductUOM"];
//    [prodDict1 setValue:@"6" forKey:@"QuantityAvail"];
//    
//    [prodDict2 setValue:@"001140032" forKey:@"ProductCode"];
//    [prodDict2 setValue:@"STERILE WATER FOR IRRIGATION 1L" forKey:@"ProductDesc"];
//    [prodDict2 setValue:@"BT" forKey:@"ProductUOM"];
//    [prodDict2 setValue:@"0" forKey:@"QuantityAvail"];
//    
//    [prodDict3 setValue:@"005305011" forKey:@"ProductCode"];
//    [prodDict3 setValue:@"NUTRITION,ENSURE PLUS, CHOCOLATE, 200ML" forKey:@"ProductDesc"];
//    [prodDict3 setValue:@"PK" forKey:@"ProductUOM"];
//    [prodDict3 setValue:@"0" forKey:@"QuantityAvail"];
//    
//    [prodDict4 setValue:@"005305012" forKey:@"ProductCode"];
//    [prodDict4 setValue:@"NUTRITION,ENSURE PLUS, STRAWBERRY, 200ML" forKey:@"ProductDesc"];
//    [prodDict4 setValue:@"PK" forKey:@"ProductUOM"];
//    [prodDict4 setValue:@"0" forKey:@"QuantityAvail"];
//    
//    [prodDict5 setValue:@"005308001" forKey:@"ProductCode"];
//    [prodDict5 setValue:@"ISOCAL LIQUID 237ML" forKey:@"ProductDesc"];
//    [prodDict5 setValue:@"PK" forKey:@"ProductUOM"];
//    [prodDict5 setValue:@"0" forKey:@"QuantityAvail"];
//    
//    [prodDict6 setValue:@"005308002" forKey:@"ProductCode"];
//    [prodDict6 setValue:@"POWDER,ISOCAL,NUTRIONALLY (850G)" forKey:@"ProductDesc"];
//    [prodDict6 setValue:@"TI" forKey:@"ProductUOM"];
//    [prodDict6 setValue:@"0" forKey:@"QuantityAvail"];
//    
//    [prodDict7 setValue:@"005308003" forKey:@"ProductCode"];
//    [prodDict7 setValue:@"NUTRITION, SUPPLEMENT POWDER (800G)" forKey:@"ProductDesc"];
//    [prodDict7 setValue:@"TI" forKey:@"ProductUOM"];
//    [prodDict7 setValue:@"117" forKey:@"QuantityAvail"];
//    
//    [prodDict8 setValue:@"005316009" forKey:@"ProductCode"];
//    [prodDict8 setValue:@"NUTRITION POWDER BENEPROTEIN 227GM" forKey:@"ProductDesc"];
//    [prodDict8 setValue:@"CAN" forKey:@"ProductUOM"];
//    [prodDict8 setValue:@"613" forKey:@"QuantityAvail"];
//    
//    [prodDict9 setValue:@"005318030" forKey:@"ProductCode"];
//    [prodDict9 setValue:@"NUTRITION, POWDER, RESOURCE THICK UP CLEAR 125G" forKey:@"ProductDesc"];
//    [prodDict9 setValue:@"CAN" forKey:@"ProductUOM"];
//    [prodDict9 setValue:@"81" forKey:@"QuantityAvail"];
//    
//    [prodDict10 setValue:@"005318031" forKey:@"ProductCode"];
//    [prodDict10 setValue:@"NURTRITION,POWDER, RESOURCE THICKUP 900G" forKey:@"ProductDesc"];
//    [prodDict10 setValue:@"TI" forKey:@"ProductUOM"];
//    [prodDict10 setValue:@"115" forKey:@"QuantityAvail"];
//    
//    [prodArray addObject:prodDict1];
//    [prodArray addObject:prodDict2];
//    [prodArray addObject:prodDict3];
//    [prodArray addObject:prodDict4];
//    [prodArray addObject:prodDict5];
//    [prodArray addObject:prodDict6];
//    [prodArray addObject:prodDict7];
//    [prodArray addObject:prodDict8];
//    [prodArray addObject:prodDict9];
//    [prodArray addObject:prodDict10];
    
  
    
    return YES;
}
-(void)getcustProducts
{
    [DBhandle updateUser_Product:userid];
    NSString *stringURL =[NSString stringWithFormat:@"%@%@.txt",FILE_URL,userid];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString  *filePath;
    if (urlData)
    {
       
        filePath = [NSString stringWithFormat:@"%@/%@.txt",documentsDirectory,userid];
        if([fileManager fileExistsAtPath: filePath])
        {
            [fileManager removeItemAtPath:filePath error:nil]; //Delete old file
        }
        NSLog(@"filepath:%@",filePath);
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
        NSArray *tArr = [[arr objectAtIndex:i] componentsSeparatedByString:@",\""];
        NSLog(@"tArr :%@",tArr);
        pitem = [[ProductItem alloc] init];
        NSString *tempStr;
        for (NSInteger j = 0; j < [tArr count]; j++)
        {
            tempStr = [tArr objectAtIndex:j];
            NSString *tStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"tStr :%@",tStr);
            if (j == 0)
            {
                NSLog(@"j == 0 ->>> %@", tStr);
                pitem.ownercode = tStr;
               // [tDict setValue:tStr forKey:@"OwnerCode"];
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
    NSLog(@"tArray:%@",tArray);
    //[tArray removeLastObject];
    
    for(int i=0;i<tArray.count;i++)
    {
        ProductItem *item =[[ProductItem alloc]init];
        item = [tArray objectAtIndex:i];
        [DBhandle adduserdetails:item user_id:userid];
        [DBhandle addproductsdetails:item];
        
        
        NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,item.productcode];
        
        if(![fileManager fileExistsAtPath: ImagePath])
        {
        NSLog(@"file :%@ not exists",item.productcode);
        UIImage *imagefromServer   = [self getImageFromURL:[NSString stringWithFormat:@"%@%@.jpg",FILE_URL,item.productcode]];
          
         [UIImageJPEGRepresentation(imagefromServer, 1.0) writeToFile:ImagePath options:NSAtomicWrite error:nil];
        }
        
       
       
        
    }
    [DBhandle deleteStatusWithOne:userid];
    [DBhandle sync:userid];
    [DBhandle getsynctime:userid];
    
    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL
    {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
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
