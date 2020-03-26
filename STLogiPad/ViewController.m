//
//  ViewController.m
//  STLogiPad
//
//  Created by Sreekumar A N on 8/22/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "ViewController.h"
#import "CartViewController.h"
#import "AppDelegate.h"
#import "customerItem.h"
#import "NetworkManager.h"
#include <CFNetwork/CFNetwork.h>

#define FTP_URL @"ftp://ztlhc:Zthost2020@119.73.235.168/outbox/"

enum {
    kSendBufferSize = 32768
};

#define BuildNo @"200326" //@"200323"     //@"200205"//@"200106"//@"20191129"

@interface ViewController ()<NSStreamDelegate>
{
     AppDelegate* appdelegate;
    UIActivityIndicatorView *spinner ;
}
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
@end

@implementation ViewController
{
    uint8_t                     _buffer[kSendBufferSize];
}
@synthesize networkStream;
@synthesize fileStream;


- (uint8_t *)buffer
{
    return self->_buffer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buildNo.text = BuildNo;
   
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self getcustinfo];
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    loginBtn.showsTouchWhenHighlighted = YES;
    

   
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self createSpinnerView];
        [self performSelector:@selector(GetCustFunc) withObject:self afterDelay:0.1];
       
        
    }
    else
    {
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *arr = [fileContent componentsSeparatedByString:@"\n"];
        appdelegate.customerArray = [[NSMutableArray alloc] init];
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
            
            
            [appdelegate.customerArray addObject:custItem];
        }
    }
    
}
-(void)GetCustFunc
{
ftpFromType = @"CUSTOMER";
NSString *hypLink = [NSString stringWithFormat:@"%@custmr.txt",FTP_URL];
NSURL *url = [NSURL URLWithString:hypLink];
NSString * utente = @"ztlhc";
NSString * codice = @"Zthost2020";

NSURLProtectionSpace * protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host port:[url.port integerValue] protocol:url.scheme realm:nil authenticationMethod:nil];

NSURLCredential *cred = [NSURLCredential
                         credentialWithUser:utente
                         password:codice
                         persistence:NSURLCredentialPersistenceForSession];


NSURLCredentialStorage * cred_storage ;
[cred_storage setCredential:cred forProtectionSpace:protectionSpace];

NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
sessionConfiguration.URLCredentialStorage = cred_storage;
sessionConfiguration.allowsCellularAccess = YES;

NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];


NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
[downloadTask resume];
}

- (IBAction)LoginPressed:(id)sender {
    
     appdelegate.islogin = YES;
    
    
    //loginBtn.selected = YES;
    
     
    BOOL isFound = NO;
    
    
     for (NSInteger j = 0; j < [appdelegate.customerArray count]; j++)
     {
         customerItem *custItem = [appdelegate.customerArray objectAtIndex:j];
         
          if ([_username.text caseInsensitiveCompare:custItem.CustCode] == NSOrderedSame && [_password.text isEqual:custItem.AuthCode])
          {
              isFound = YES;
              [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"login"];
              [[NSUserDefaults standardUserDefaults] setValue:custItem.CustCode forKey:@"username"];
               [[NSUserDefaults standardUserDefaults] setValue:custItem.warehousecode forKey:@"warehousecode"];
               [[NSUserDefaults standardUserDefaults] setValue:custItem.ownercode forKey:@"ownercode"];
               [[NSUserDefaults standardUserDefaults] setValue:custItem.EmailAddr forKey:@"email"];
               [[NSUserDefaults standardUserDefaults] setValue:custItem.CcAddr forKey:@"cc"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              appdelegate.warehousecode = custItem.warehousecode;
              appdelegate.userid = custItem.CustCode;
              appdelegate.emailaddr = custItem.EmailAddr;
              appdelegate.ccaddr = custItem.CcAddr;
              appdelegate.ownerCode = custItem.ownercode;
              NSLog(@"custItem.ownercode %@",custItem.ownercode);
              
              [self uploadPendingOrderIfAny];
             
              CartViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
              [self presentViewController:cv animated:YES completion:nil];
              
              
              
       
              break;
          }
     }
    
   if(!isFound)
   {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid username/Password" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
       [alert show];
   }
   
}
-(void)uploadPendingOrderIfAny
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath:@"order.txt"]])
    {
        NSDateFormatter* dtFormat = [[NSDateFormatter alloc] init];
        [dtFormat setDateFormat:@"yyyyMMddhhmmss"];
        NSString *newOrdFile = [NSString stringWithFormat:@"order-%@-%@.txt", appdelegate.userid, [dtFormat stringFromDate:[NSDate date]]];
        
        NSLog(@"new order path - %@", newOrdFile);
        
        NSError *error;
        if ([[NSFileManager defaultManager] copyItemAtPath:[self dataFilePath:@"order.txt"] toPath:[self dataFilePath:newOrdFile]  error:&error] != YES)
        {
            NSLog(@"Unable to move file: %@", [error localizedDescription]);
        }
        
       [self uploadtxtFile:[self dataFilePath:newOrdFile]];
    }
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

#pragma mark Session Download Delegate Methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    
    NSLog(@"errors %@",error.debugDescription);
    if(error != NULL )
    {
        [spinner stopAnimating];
        UIView *view=[self.view viewWithTag:8887];
        [view removeFromSuperview];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Problem....Please try after sometime" message:error.debugDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __nullable))completionHandler
{
    NSLog(@"credential ");
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    
    NSString *stringToWrite = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSError *error = nil;
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:downloadTask.originalRequest.URL.lastPathComponent];
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    NSString* fileContent = [NSString stringWithContentsOfURL:location];
    NSLog(@"dataaa:%@",fileContent);
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([ftpFromType isEqualToString:@"CUSTOMER"])
        {
            NSArray *arr = [fileContent componentsSeparatedByString:@"\n"];
            appdelegate.customerArray = [[NSMutableArray alloc] init];
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
                
                
                [appdelegate.customerArray addObject:custItem];
            }
            
            NSLog(@"cust:%@",appdelegate.customerArray);
        }
  
        [spinner stopAnimating];
        UIView *view=[self.view viewWithTag:8887];
        [view removeFromSuperview];
        [appdelegate.DBhandle getsynctime];
        [[NSUserDefaults standardUserDefaults] setValue:appdelegate.syncDateTime forKey:@"datetime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"progress %f",progress);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.progressView setProgress:progress];
    });
}
#pragma mark Uploading delegate methods


- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        
        NSLog(@"put succeeded");
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


- (NSString *)dataFilePath:(NSString *)inputName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:inputName];
}

-(void) createSpinnerView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor=[UIColor blackColor];
    view.alpha = 0.5;
    view.tag = 8887;
    
    spinner = [UIActivityIndicatorView alloc];
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2 , 60, 60);
    spinner.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2 );
    spinner.hidesWhenStopped=YES;
    spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    spinner.transform = transform;
    
    [view addSubview:spinner];
    [self.view addSubview:view];
    
    [spinner startAnimating];
}

@end
