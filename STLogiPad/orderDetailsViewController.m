//
//  orderDetailsViewController.m
//  STLogiPad
//
//  Created by Sreekumar A N on 10/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "orderDetailsViewController.h"
#import "CartTableViewCell.h"
#import "ProductItem.h"
#import "AppDelegate.h"
#import "CartViewController.h"
#import "Reachability.h"
#import "NetworkManager.h"
#include <CFNetwork/CFNetwork.h>

enum {
    kSendBufferSize = 32768
};

@interface orderDetailsViewController ()<NSStreamDelegate>
{
    __weak IBOutlet UILabel *OrderSendErrorLabel;
    AppDelegate *appdelegate;
     NSString *newOrdFile;
}
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
@end





@implementation orderDetailsViewController{
    uint8_t                     _buffer[kSendBufferSize];
}
@synthesize networkStream;
@synthesize fileStream;

@synthesize dateTimeString;

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
     backBtn.showsTouchWhenHighlighted = YES;
    
    [ReorderBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
    ReorderBtn.showsTouchWhenHighlighted = YES;
    
   
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appdelegate.selectedOrderStatus isEqualToString:@"Pending"])
    {
        [ReorderBtn setTitle:@"Submit" forState:UIControlStateNormal];
        OrderSendErrorLabel.hidden = NO;
    }
    else
         OrderSendErrorLabel.hidden = YES;
    [dateTime setTitle:dateTimeString forState:UIControlStateNormal];
    appdelegate.isNeedAlert = NO;
    // Do any additional setup after loading the view.
}
#pragma mark Uploading delegate methods


- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        NSError *error;
        NSLog(@"put succeeded");
        [self performSelector:@selector(showOrderAlert)  withObject:nil afterDelay:0];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyMMddHHmm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        
        NSString *currOrdNum = [NSString stringWithFormat:@"%@%@",appdelegate.userid, dateString];
        
        NSString *subjStr = [NSString stringWithFormat:@"ST Healthcare Inventory Cart   -   Order Number: %@   -   CustCode: %@   -   Warehouse Code: %@", currOrdNum, appdelegate.userid,appdelegate.warehousecode];
        
        
        
        
        //***************Changes for mail sending (via Email)***************
        
        NSMutableArray *mailArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i < [appdelegate.orderDetailsArray count]; i++)
        {
            NSDictionary *Orderdetails;
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem = [appdelegate.orderDetailsArray objectAtIndex:i];
            int qty;
            NSLog(@"pitem :%d",pitem.par);
            if(pitem.par == 0)
                qty = pitem.StdPackDet;
            else
                qty = pitem.par;
            
            Orderdetails = [[NSDictionary alloc] initWithObjectsAndKeys:pitem.productcode, @"productcode",pitem.proddescription,@"proddescription",pitem.productuom, @"uom",[NSNumber numberWithInt:qty], @"par",nil];
           
            [mailArray addObject:Orderdetails];
            
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mailArray
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString :%@",jsonString);
        
        NSArray *toItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] componentsSeparatedByString:@";"];
        
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:toItems
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error];
        NSString *jsonString1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        
        jsonString1 = [jsonString1 stringByReplacingOccurrencesOfString:@"[" withString:@""];
        jsonString1 = [jsonString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        
        
        NSArray *ccItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cc"] componentsSeparatedByString:@";"];
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:ccItems
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error];
        NSString *jsonString2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        
        jsonString2 = [jsonString2 stringByReplacingOccurrencesOfString:@"[" withString:@""];
        jsonString2 = [jsonString2 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSLog(@"jsonstring2 :%@",jsonString2);
        NSString *resp = [self sendEmail:jsonString subject:subjStr ToRecipients:jsonString1 CcRecipients:jsonString2];
        resp = [resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        [appdelegate.DBhandle deleteOrderstatus_detailsWithStatusPending:appdelegate.SelectedOrderid];
        [appdelegate.DBhandle addOrderStatus:appdelegate.userid totalItm:appdelegate.orderDetailsArray.count sts:@"Submitted"];
        [appdelegate.DBhandle addOrderDetailsFromPendingStatus];
        
        CartViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
        [self presentViewController:cv animated:YES completion:nil];
        
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath:newOrdFile] error:nil];
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Order NOT submitted" message:@"There was a problem in submitting the order.  Please inform Technical Support team about the problem..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    
    
    
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened connection");
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"sending");
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.orderDetailsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
        static NSString *CellIdentifier = @"CartTableViewCell";
        CartTableViewCell *cell = (CartTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];//dequeing cell from tableview. And if it is nil, initialize new cell instance
        if (cell == nil){
            
            cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CartTableViewCell"];
        }
        if( [indexPath row] % 2){
            cell.backgroundColor=[UIColor whiteColor];
            
        }
        else{
             cell.backgroundColor=[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:1.0f];
                                  //colorWithRed:28.0f/255 green:175.0f/255 blue:135.0f/255 alpha:1.0f];
        }
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.orderDetailsArray objectAtIndex:indexPath.row];
        cell.SLNo.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        cell.Desc.text = pitem.proddescription;
        cell.UOM.text = pitem.productuom;
        cell.Qty.text =[NSString stringWithFormat:@"%d",pitem.StdPackDet];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,pitem.productcode];
    UIImage *image = [UIImage imageWithContentsOfFile:ImagePath];
    if(image == nil)
        image = [UIImage imageNamed:@"no-image.png"];
    
    cell.Pimage.image = image;

    
        return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnPressed:(id)sender {
    
    backBtn.selected = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ReorderBtnPressed:(id)sender {
    
     ReorderBtn.selected = YES;
    
    if([appdelegate.selectedOrderStatus isEqualToString:@"Pending"])
    {
   
        NSString *custFileContent = @"";
        NSDateFormatter* dtFormat = [[NSDateFormatter alloc] init];
        NSString *currDateTime;
        NSString *currOrdNum;
        unichar asciiCR = 13; // \r
        unichar asciiLF = 10; // \n
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyMMddHHmmss"];
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        BOOL isquantZero = NO;
        for (int i=0;i< appdelegate.orderDetailsArray.count ; i++)
        {
            [dtFormat setDateFormat:@"dd/MM/yyyy"];
            currDateTime = [dtFormat stringFromDate:[NSDate date]];
            
            currOrdNum = [NSString stringWithFormat:@"%@%@", appdelegate.userid, dateString];
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem = [appdelegate.orderDetailsArray objectAtIndex:i];
            if(pitem.StdPackDet!=0)
            {
                custFileContent = [NSString stringWithFormat:@"\"%@\"|\"%@\"|\"%@\"|\"%@\"|\"%@\"|\"%@\"|\"%@\"%@%@%@", appdelegate.ownerCode, appdelegate.warehousecode,appdelegate.userid, currDateTime, currOrdNum, pitem.productcode , [NSString stringWithFormat:@"%d", pitem.par] , [NSString stringWithCharacters:&asciiCR length:1], [NSString stringWithCharacters:&asciiLF length:1], custFileContent];
            }
            else
            {
                isquantZero = YES;
                break;
                
            }
        }
        
        if(isquantZero == NO)
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath:@"order.txt"]])
            {
                NSLog(@"file dun exist");
                [custFileContent writeToFile:[self dataFilePath:@"order.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            
            else
            {
                NSLog(@"file exist");
                NSString *tempStr = [NSString stringWithContentsOfFile:[self dataFilePath:@"order.txt"] encoding:NSUTF8StringEncoding error:nil];
                custFileContent = [NSString stringWithFormat:@"%@%@", tempStr, custFileContent];
                [custFileContent writeToFile:[self dataFilePath:@"order.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            
            newOrdFile = [NSString stringWithFormat:@"order-%@%@.txt", appdelegate.userid, dateString];
            
            NSLog(@"new order path - %@", newOrdFile);
            
            NSError *error;
            if ([[NSFileManager defaultManager] copyItemAtPath:[self dataFilePath:@"order.txt"] toPath:[self dataFilePath:newOrdFile]  error:&error] != YES)
            {
                NSLog(@"Unable to move file: %@", [error localizedDescription]);
            }
            if ([self checkReachability])
            {
                 [self uploadtxtFile:[self dataFilePath:newOrdFile]];
                
            }
            else
            {
                [self showAlert];
            }
    
    }
    }
    else
    {
    
    for (int i=0;i< appdelegate.orderDetailsArray.count ; i++)
    {
        
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.orderDetailsArray objectAtIndex:i];
        [appdelegate.DBhandle addToCart:pitem userid:appdelegate.userid];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d items added to cart",appdelegate.orderDetailsArray.count] message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    CartViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self presentViewController:cv animated:YES completion:nil];
    }
    
    
}
-(BOOL)checkReachability {
        
        Reachability *internetReach;
        internetReach = [Reachability reachabilityForInternetConnection];
        [internetReach startNotifer];
        NetworkStatus netStatus = [internetReach currentReachabilityStatus];
        if(netStatus == NotReachable) {
            return NO;
        } else {
            return YES;
        }
    }
    -(void)showOrderAlert
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath:@"order.txt"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath:newOrdFile] error:nil];
        
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Order Sent" message:@"Your order has been uploaded successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    -(void)showAlert{
        
       
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath:newOrdFile] error:nil];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check your network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    -(NSString *)sendEmail:(NSString *)Orderdetails subject:(NSString *)subjStr ToRecipients:(NSString*)toItems CcRecipients:(NSString*)ccItems
    {
        NSURL *serverURL = [NSURL URLWithString:@"http://www.scholartools.com/ios/STH/SendEmail.php"];
        NSLog(@"check version url %@",serverURL);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
        
        NSMutableString * post = [NSMutableString new];
        [post appendString:[NSString stringWithFormat:@"&orderdetails=%@",Orderdetails]];
        [post appendString:[NSString stringWithFormat:@"&subjStr=%@",subjStr]];
        [post appendString:[NSString stringWithFormat:@"&torecipients=%@",toItems]];
        [post appendString:[NSString stringWithFormat:@"&ccrecipients=%@",ccItems]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [request setHTTPBody:postData];
        
        NSError *WSerror;
        
        NSURLResponse *WSresponse;
        
        NSMutableData *mutableResponseData;
        
        mutableResponseData = [[NSMutableData alloc ] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&WSresponse error:&WSerror]];
        
        NSString * responseString = [[NSMutableString alloc] initWithData:mutableResponseData encoding:NSUTF8StringEncoding];
        NSLog(@"response %@",responseString);
        return responseString;
    }
    - (void)uploadtxtFile:(NSString *)filePath
    {
        NSURL *url = [[NetworkManager sharedInstance] smartURLForString:@"ftp://119.73.235.168/inbox/"];
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        assert(self.networkStream != nil);
        
        [self.networkStream setProperty:@"ztlhc" forKey:(id)kCFStreamPropertyFTPUserName];
        [self.networkStream setProperty:@"Zthost2020" forKey:(id)kCFStreamPropertyFTPPassword];
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        [[NetworkManager sharedInstance] didStartNetworkOperation];
}
- (NSString *)dataFilePath:(NSString *)inputName
{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingPathComponent:inputName];
}
@end
