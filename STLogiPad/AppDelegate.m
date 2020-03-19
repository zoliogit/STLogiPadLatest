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




@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize SelProdCode,prodArray,cartArray,favArray,DBhandle,userid,SelectedpItem,syncDateTime,currentOrderId,orderArray,orderDetailsArray,islogin,isFromQR,customerArray,warehousecode,emailaddr,ccaddr,SyncprodArray,ownerCode,ExcelPAR,isNeedAlert,SelectedOrderid,selectedOrderStatus,imagesynctime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    isFromQR = NO;
    DBhandle=[DBHandler alloc];
    SelectedpItem = [[ProductItem alloc] init];
    [DBhandle createEditableCopyOfDatabaseIfNeeded];
    islogin = NO;
    isNeedAlert = YES;
    cartArray = [[NSMutableArray alloc]init];
    favArray = [[NSMutableArray alloc]init];
    orderArray = [[NSMutableArray alloc]init];
    orderDetailsArray = [[NSMutableArray alloc]init];
    

    
   
    
   // [self uploadImagesToDocument];

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



-(void)uploadImagesToDocument
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    
    NSArray *dirContents = [fileManager contentsOfDirectoryAtPath: bundleRoot error: &error];
    
    NSArray *onlyjpg = [dirContents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"self ENDSWITH '.jpg'"]];
    NSLog(@"onlyjpg :%@",onlyjpg);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex: 0];
    for (int i = 0; i < onlyjpg.count; i++) {
        NSString *pdfName = [dirContents objectAtIndex: i];
        
        NSString *docPdfFilePath = [documentsDir stringByAppendingPathComponent: pdfName];
        
        //Using NSFileManager we can perform many file system operations.
        BOOL success = [fileManager fileExistsAtPath: docPdfFilePath];
        
        if (!success) {
            NSString *samplePdfFile  = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: pdfName];
            
            success = [fileManager copyItemAtPath: samplePdfFile toPath: docPdfFilePath error: &error];
            if (!success)
                //              NSAssert1(0, @"Failed to copy file ‘%@’.", [error localizedDescription]);
                NSLog(@"Failed to copy %@ file, error %@", pdfName, [error localizedDescription]);
            else {
                NSLog(@"File copied %@ OK", pdfName);
            }
        }
        else {
            NSLog(@"File exits %@, skip copy", pdfName);
        }
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
