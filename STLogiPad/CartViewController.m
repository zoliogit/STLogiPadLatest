//
//  CartViewController.m
//  STLogiPad
//
//  Created by Sreekumar A N on 8/25/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "AppDelegate.h"
#import "ProdDescViewController.h"
#import "ViewController.h"
#import "FavTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ProductItem.h"
#import <MessageUI/MessageUI.h>
#import "OrderStatusViewController.h"



@interface CartViewController ()
{
    NSArray *productList;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    UIActivityIndicatorView *spinner ;
   // UIButton *favCartBtn;
}

@end

@implementation CartViewController
{
    AppDelegate* appdelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [favBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   
    favBtn.showsTouchWhenHighlighted = YES;
    
    [syncBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   syncBtn.showsTouchWhenHighlighted = YES;
    
    [productsBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   productsBtn.showsTouchWhenHighlighted = YES;
    
    [FavCartBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage185x50.png"] forState:UIControlStateNormal];
    
   FavCartBtn.showsTouchWhenHighlighted = YES;
    
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   submitBtn.showsTouchWhenHighlighted = YES;
    
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   scanBtn.showsTouchWhenHighlighted = YES;
    
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage185x50.png"] forState:UIControlStateNormal];
    
    orderBtn.showsTouchWhenHighlighted = YES;
    
   
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    isLogout = NO;
    favcartArray = [[NSMutableArray alloc]init];
    tempArray = [[NSMutableArray alloc]init];
    NSLog(@"appdelegate.islogin :%d",appdelegate.islogin);
    if(appdelegate.islogin == NO)
    {
       
        appdelegate.userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        [appdelegate getcustProducts];
    }
    
    [loggedBtn setTitle:[NSString stringWithFormat:@"Logged in as %@:",appdelegate.userid] forState:UIControlStateNormal];
    
    //favTable.allowsMultipleSelection = YES;
  //  favCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button addTarget:self
              // action:@selector(aMethod:)
     //forControlEvents:UIControlEventTouchUpInside];
    //[favCartBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
    
    
     [appdelegate.DBhandle getproductsdetails:appdelegate.userid];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
    
    
     BOOL today = [[NSCalendar currentCalendar] isDateInToday:[dateFormatter dateFromString:appdelegate.syncDateTime]];
    NSArray *seperateString = [appdelegate.syncDateTime componentsSeparatedByString:@" "];
    
    if(today)
    {
        appdelegate.syncDateTime = [NSString stringWithFormat:@"Today %@ %@",seperateString[1],seperateString[2]];
    }
    else
    {
    BOOL yesterday = [[NSCalendar currentCalendar] isDateInYesterday:[dateFormatter dateFromString:appdelegate.syncDateTime]];
    
    NSLog(@"date :%d",yesterday);
    
    if(yesterday)
    {
        
        appdelegate.syncDateTime = [NSString stringWithFormat:@"Yesterday %@ %@",seperateString[1],seperateString[2]];
    }
    }
    
     [dateString setTitle:appdelegate.syncDateTime forState:UIControlStateNormal];
     [cartTable reloadData];
    
     productListPopOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductListPopOverViewController"];
    
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [appdelegate.DBhandle getcart:appdelegate.userid];
    [appdelegate.DBhandle getfav:appdelegate.userid];
    NSLog(@"prodArray:%@",appdelegate.prodArray);
    NSLog(@"cartArray:%@",appdelegate.cartArray);
    [cartTable reloadData];
    [favTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
if(tableView == productListTable)
return [appdelegate.prodArray count];
if(tableView == cartTable)
return [appdelegate.cartArray count];
if(tableView == favTable)
return [appdelegate.favArray count];
else
return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == cartTable)
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
            cell.backgroundColor=[UIColor lightGrayColor];
                                  //colorWithRed:28.0f/255 green:175.0f/255 blue:135.0f/255 alpha:1.0f];
        }
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.cartArray objectAtIndex:indexPath.row];
        cell.SLNo.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        cell.Desc.text = pitem.proddescription;
        cell.UOM.text = pitem.productuom;
        cell.Qty.text =[NSString stringWithFormat:@"%d",pitem.quantity];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,pitem.productcode];
        UIImage *image = [UIImage imageWithContentsOfFile:ImagePath];
        if(image == nil)
            image = [UIImage imageNamed:@"no-image.png"];
            
        cell.Pimage.image = image;
        
        return cell;
    }
    if(tableView == productListTable)
    {
        static NSString *CellIdent = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdent];
    }
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.prodArray objectAtIndex:indexPath.row];
        
    cell.textLabel.text = pitem.proddescription;
    
    return cell;
        
    }
    if(tableView == favTable)
    {
        
        static NSString *CellIdentifier = @"FavTableViewCell";
        FavTableViewCell *cell = (FavTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];//dequeing cell from tableview. And if it is nil, initialize new cell instance
        if (cell == nil){
            
            cell = [[FavTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavTableViewCell"];
        }
         ProductItem *pitem = [[ProductItem alloc] init];
       pitem = [appdelegate.favArray objectAtIndex:indexPath.row];
        
        cell.productDesc.text = pitem.proddescription;
        [cell.CheckBxBtn setImage:[UIImage imageNamed:@"checkBoxDeSelect.png"] forState:UIControlStateNormal];
        cell.CheckBxBtn.tag = indexPath.row;
        [cell.CheckBxBtn addTarget:self action:@selector(ChckBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == favTable)
    {
        
                ProductItem *pitem = [[ProductItem alloc] init];
                pitem = [appdelegate.favArray objectAtIndex:indexPath.row];
                [appdelegate.DBhandle deletefromfav:pitem userid:appdelegate.userid];
                [appdelegate.DBhandle getfav:appdelegate.userid];
               [favTable reloadData];
        
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [popoverController dismissPopoverAnimated:YES];
    if(tableView == productListTable)
    {
      ProductItem *pitem = [[ProductItem alloc] init];
      pitem = [appdelegate.prodArray objectAtIndex:indexPath.row];
    appdelegate.SelectedpItem = pitem;
      NSLog(@"appdelegate.SelProdCode :%@",appdelegate.SelProdCode);
        appdelegate.isFromQR = NO;
      ProdDescViewController *pdv = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDescViewController"];
      [self presentViewController:pdv animated:YES completion:nil];
     }
     if(tableView == cartTable)
     {
         ProductItem *pitem = [[ProductItem alloc] init];
         pitem = [appdelegate.cartArray objectAtIndex:indexPath.row];
         appdelegate.SelectedpItem = pitem;
         NSLog(@"appdelegate.SelProdCode :%@",appdelegate.SelProdCode);
         ProdDescViewController *pdv = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDescViewController"];
         [self presentViewController:pdv animated:YES completion:nil];
         
     }
    if(tableView == favTable)
    {
        [popoverController dismissPopoverAnimated:NO];
        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        dict = [appdelegate.favArray objectAtIndex:indexPath.row];
//        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//         cell.accessoryType = UITableViewCellAccessoryCheckmark;
//
//       [favcartArray addObject:dict];
//
        
       // NSLog(@"favcartArray:%@",favcartArray);
    }
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)ChckBtnPressed:(id)sender
{
     UIButton *tempBtn=(UIButton *) sender;
    ProductItem *pitem = [[ProductItem alloc] init];
    pitem = [appdelegate.favArray objectAtIndex:tempBtn.tag];
   
    if(tempBtn.selected)
    {
        [tempBtn setImage:[UIImage imageNamed:@"checkBoxDeSelect.png"] forState:UIControlStateNormal];
        tempBtn.selected = NO;
        [tempArray removeObject:pitem];
        
    }
    else
    {
      [tempBtn setImage:[UIImage imageNamed:@"checkBoxSelect.png"] forState:UIControlStateNormal];
        tempBtn.selected = YES;
        [tempArray addObject:pitem];
    }
}

- (IBAction)productsClicked:(id)sender
{
    productsBtn.selected = YES;
    
    productListTable.hidden = NO;
    productListTable.frame = CGRectMake(0, 0, 400, 460);
        
     if (!popoverController) {
         
         
         popoverController = [[UIPopoverController alloc] initWithContentViewController:productListPopOverViewController];
         popoverController.delegate = self;
         
     }
    [productListPopOverViewController.view addSubview:productListTable];
    
    
    
    [popoverController setPopoverContentSize:CGSizeMake(400, 460) animated:YES];
    [popoverController presentPopoverFromRect:productsBtn.frame
                                       inView:productsBtn.superview
                     permittedArrowDirections:UIPopoverArrowDirectionRight
                                     animated:YES];
    [productListTable reloadData];
}

- (IBAction)ScnBtnClicked:(id)sender {
    
     scanBtn.selected = YES;
    
    ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    [self presentViewController:codeReader animated:YES completion:nil];
    
   
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
   
    
    
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    // showing the result on textview
   
    
    NSString *scannedCode = symbol.data;//@"001140030|10";//symbol.data;
    if ([scannedCode rangeOfString:@"|"].location == NSNotFound)
    {
        //[reader dismissModalViewControllerAnimated: YES];
        
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Invalid Code!" message:@"The scanned code is invalid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
       
        return;
    }
    NSString *pdtCode = [scannedCode substringToIndex:([scannedCode rangeOfString:@"|"].location)];
    NSString *quanStr = [scannedCode substringFromIndex:([scannedCode rangeOfString:@"|"].location + 1)];
     NSLog(@"pdtCode: %@", pdtCode);
    NSLog(@"quanStr: %@", quanStr);
    BOOL found = NO;
    for(int i=0; i< appdelegate.prodArray.count;i++)
    {
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.prodArray objectAtIndex:i];
        if([pitem.productcode isEqualToString:pdtCode])
        {
            pitem.QRQuantity = [quanStr integerValue];
            appdelegate.SelectedpItem = pitem;
            found = YES;
        }
        
    }
    
    [reader dismissModalViewControllerAnimated: YES];
    if(found)
    {
        appdelegate.isFromQR = YES;
        ProdDescViewController *pdv = [self.storyboard instantiateViewControllerWithIdentifier:@"ProdDescViewController"];
        [self presentViewController:pdv animated:YES completion:nil];
    }
    else
    {
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Product Mismatch!" message:@"The scanned code does not match any product in the inventory." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    }
        
    
    
    // dismiss the controller
   // [reader dismissViewControllerAnimated:YES completion:nil];
}



//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    //imageView.image = image;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//
//
//}
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissModalViewControllerAnimated:YES];
//}







- (IBAction)FavbtnClicked:(id)sender {
    
    favBtn.selected = YES;
    NSLog(@"app;%@",appdelegate.favArray);
    [productListTable removeFromSuperview];
    favTable.hidden = NO;
    favTable.frame = CGRectMake(0,60, 450, 460);
    FavCartBtn.hidden = NO;
   FavCartBtn.frame = CGRectMake(225,10, 160, 40);
    [productListPopOverViewController.view addSubview:FavCartBtn];

    if (!popoverController) {


        popoverController = [[UIPopoverController alloc] initWithContentViewController:productListPopOverViewController];
        popoverController.delegate = self;

    }
   
    [productListPopOverViewController.view addSubview:favTable];



    [popoverController setPopoverContentSize:CGSizeMake(450, 460) animated:YES];
    [popoverController presentPopoverFromRect:favBtn.frame
                                       inView:favBtn.superview
                     permittedArrowDirections:UIPopoverArrowDirectionLeft
                                     animated:YES];
    [favTable reloadData];
}

- (IBAction)backBtnPressed:(id)sender {
}

- (IBAction)SubBtnPressed:(id)sender {
    
    submitBtn.selected = YES;
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"New Order Details"];
        
        NSString *tableFirstLine = @"<table width='100%' border='1'><tr align='center' ><td> SL_No </td><td> ProductCode </td><td> Description </td><td> UOM </td><td> Quantity </td></tr>";
        NSString *messageBody = @"";
        messageBody = [messageBody stringByAppendingFormat:@"%@", tableFirstLine];
        for (int i=0; i < [appdelegate.cartArray count]; i++)
        {
          ProductItem *pitem = [[ProductItem alloc] init];
          pitem = [appdelegate.cartArray objectAtIndex:i];
          messageBody = [messageBody stringByAppendingFormat:@"<tr align='center'><td>"];
          messageBody = [messageBody stringByAppendingFormat:@"%d",i+1];
          messageBody = [messageBody stringByAppendingFormat:@"</td><td>"];
          messageBody = [messageBody stringByAppendingFormat:@"%@",pitem.productcode];
          messageBody = [messageBody stringByAppendingFormat:@"</td><td>"];
          messageBody = [messageBody stringByAppendingFormat:@"%@",pitem.proddescription];
          messageBody = [messageBody stringByAppendingFormat:@"</td><td>"];
          messageBody = [messageBody stringByAppendingFormat:@"%@",pitem.productuom];
          messageBody = [messageBody stringByAppendingFormat:@"</td><td>"];
          messageBody = [messageBody stringByAppendingFormat:@"%d",pitem.quantity];
          messageBody = [messageBody stringByAppendingFormat:@"</td></tr>"];
            if (i == [appdelegate.cartArray count]) {
                //IF THIS IS THE LAST INGREDIENT, CLOSE THE TABLE
                messageBody  = [messageBody  stringByAppendingFormat:@"</table>"];
            }
        }
        NSLog(@"message:%@",messageBody);
        [mail setMessageBody:messageBody isHTML:YES];
        [mail setToRecipients:@[@"dharsana@zoliotech.com"]];
        [mail setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
        {
            NSLog(@"You sent the email.");
            [appdelegate.DBhandle addOrderStatus:appdelegate.userid totalItm:appdelegate.cartArray.count];
            [appdelegate.DBhandle addOrderDetails];
            
            for(int i=0; i<appdelegate.cartArray.count; i++)
            {
                ProductItem *pitem = [[ProductItem alloc] init];
                pitem = [appdelegate.cartArray objectAtIndex:i]; 
                [appdelegate.DBhandle deletefromcart:pitem userid:appdelegate.userid];
            }
            
            [appdelegate.cartArray removeAllObjects];
            [cartTable reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email sent!" message:@"The orders email have been sent successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)LogoutBtnPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    isLogout=YES;
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:[NSString stringWithFormat:@"Hi %@..",appdelegate.userid]
                        message:@"Do you want to Logout ?"
                        delegate:self
                        cancelButtonTitle:@"YES"
                        otherButtonTitles:@"NO", nil];
    [tmp show];
    
    
    
}

- (IBAction)OrderBtnPressed:(id)sender {
    
    
    orderBtn.selected = YES;
    OrderStatusViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)FavCartBtnPressed:(id)sender
{
    
    FavCartBtn.selected = YES;
    bool isalready = 0;
    for(int i=0;i<tempArray.count;i++)
    {
       ProductItem *pitem = [[ProductItem alloc] init];
       pitem = [tempArray objectAtIndex:i];
       isalready =[appdelegate.DBhandle addToCart:pitem userid:appdelegate.userid];
//        if(!isalready)
//            [tempArray removeObjectAtIndex:i];
    }
   
//    for(int i=0;i<tempArray.count;i++)
//    {
//        ProductItem *pitem = [[ProductItem alloc] init];
//        pitem = [tempArray objectAtIndex:i];
//        [appdelegate.DBhandle deletefromfav:pitem userid:appdelegate.userid];
//    }
//    [appdelegate.DBhandle getfav:appdelegate.userid];
    
    
    [appdelegate.DBhandle getcart:appdelegate.userid];
    [favTable reloadData];
    [cartTable reloadData];
    [tempArray removeAllObjects];
    
//    if(!isalready)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Product already in cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//    }

    [popoverController dismissPopoverAnimated:YES];
}

- (IBAction)syncBtnClicked:(id)sender
{
    syncBtn.selected = YES;
    [self createSpinnerView];
    [self performSelector:@selector(callFunc) withObject:self afterDelay:0.1];
//    [spinner stopAnimating];
//    UIView *view=[self.view viewWithTag:8887];
//    [view removeFromSuperview];
    
}
-(void)callFunc
{
    [appdelegate getcustProducts];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
    
    
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:[dateFormatter dateFromString:appdelegate.syncDateTime]];
    NSArray *seperateString = [appdelegate.syncDateTime componentsSeparatedByString:@" "];
    
    if(today)
    {
        appdelegate.syncDateTime = [NSString stringWithFormat:@"Today %@ %@",seperateString[1],seperateString[2]];
    }
    BOOL yesterday = [[NSCalendar currentCalendar] isDateInYesterday:[dateFormatter dateFromString:appdelegate.syncDateTime]];
    
    NSLog(@"date :%d",yesterday);
    
    if(yesterday)
    {
        
        appdelegate.syncDateTime = [NSString stringWithFormat:@"Yesterday %@ %@",seperateString[1],seperateString[2]];
    }
    
    [dateString setTitle:appdelegate.syncDateTime forState:UIControlStateNormal];
    [appdelegate.DBhandle getproductsdetails:appdelegate.userid];
    [productListTable reloadData];
    [spinner stopAnimating];
    UIView *view=[self.view viewWithTag:8887];
    [view removeFromSuperview];
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
       if(isLogout)
       {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:vc animated:YES completion:nil];
       }
        
    }
    else
    {
        isLogout = NO;
    }
}
@end
