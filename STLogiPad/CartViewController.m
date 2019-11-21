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
#import "customerItem.h"

#define FILE_URL @"http://www.scholartools.com/ios/STH/uploaded_files/"

@interface CartViewController ()
{
    NSArray *productList;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    UIActivityIndicatorView *spinner ;
    
    NSMutableArray *filteredproducts;
    
    BOOL isFiltered;
     BOOL isImageDownloadComplete;
   // UIButton *favCartBtn;
}

@end

@implementation CartViewController
{
    AppDelegate* appdelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFiltered = false;
    isImageDownloadComplete = NO;
    NSLog(@"email :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
    NSArray *listItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cc"] componentsSeparatedByString:@";"];
    NSLog(@"cc :%@ %@ %@",listItems[0],listItems[1],listItems[2]);
    [favBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    self.searchBar.delegate = self;
   
    filteredproducts = [[NSMutableArray alloc]init];
    
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
        appdelegate.warehousecode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"warehousecode"];
        appdelegate.syncDateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"datetime"];
        NSLog(@"dat :%@",appdelegate.syncDateTime);
       
    }
    
     [loggedBtn setTitle:[NSString stringWithFormat:@"Logged in as %@:",appdelegate.userid] forState:UIControlStateNormal];
    
    //favTable.allowsMultipleSelection = YES;
  //  favCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button addTarget:self
              // action:@selector(aMethod:)
     //forControlEvents:UIControlEventTouchUpInside];
    //[favCartBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
    
    
     //[appdelegate.DBhandle getproductsdetails:appdelegate.userid];
    
    [appdelegate.DBhandle getproductsdetails];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
    
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        isFiltered = false;
        
        [self.searchBar endEditing:YES];
        
    }
    
    else {
        
        isFiltered = true;
        
        filteredproducts = [[NSMutableArray alloc]init];
        
        for(int i=0;i<appdelegate.prodArray.count;i++)
        {
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem = [appdelegate.prodArray objectAtIndex:i];
            NSRange range = [pitem.proddescription rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                
                [filteredproducts addObject:pitem.proddescription];
                
            }
        }
        
       
    }
    NSLog(@"filteredproducts:%@",filteredproducts);
    [productListTable reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if(tableView == productListTable)
{
    if (isFiltered) {
        
        return filteredproducts.count;
        
    }
return [appdelegate.prodArray count];
}
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
            cell.backgroundColor=[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:1.0f];
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
    
    if (isFiltered) {
            
            cell.textLabel.text= [filteredproducts objectAtIndex:indexPath.row];
            
        }
        else
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
        
      if (isFiltered)
      {
          for(int i=0;i<appdelegate.prodArray.count;i++)
          {
              ProductItem *pitem = [[ProductItem alloc] init];
              pitem = [appdelegate.prodArray objectAtIndex:i];

              if([pitem.proddescription isEqualToString:[filteredproducts objectAtIndex:indexPath.row]])
              {
                  appdelegate.SelectedpItem = pitem;
              }
          }
          
      }
        else
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
    favTable.frame = CGRectMake(0,60, 400, 460);
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
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
       [dateFormat setDateFormat:@"yyMMddHHmm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        
        NSString *currOrdNum = [NSString stringWithFormat:@"%@%@",appdelegate.userid, dateString];
        
        NSString *subjStr = [NSString stringWithFormat:@"ST Healthcare Inventory Cart   -   Order Number: %@   -   CustCode: %@   -   Warehouse Code: %@", currOrdNum, appdelegate.userid,appdelegate.warehousecode];
        
        [mail setSubject:subjStr];
        
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
         NSArray *emailItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] componentsSeparatedByString:@";"];
        
        
        [mail setToRecipients:emailItems];
        
        
        NSArray *listItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cc"] componentsSeparatedByString:@";"];
        
       
        [mail setCcRecipients:listItems];
        
        
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

    
}


-(void)callFunc
{
    [self syncCall];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];


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
    [appdelegate.DBhandle getproductsdetails];
    [productListTable reloadData];
    [spinner stopAnimating];
    UIView *view=[self.view viewWithTag:8887];
    [view removeFromSuperview];
    
}
-(void)syncCall
{
    //Update customer info
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString  *filePath;
    filePath = [NSString stringWithFormat:@"%@/custmr.txt",documentsDirectory];
    NSString *stringURL = [NSString stringWithFormat:@"%@custmr.txt",FILE_URL];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        [urlData writeToFile:filePath atomically:YES];
    }



    //update product details...

    [appdelegate.DBhandle updateUser_Product];

  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
   fileManager = [NSFileManager defaultManager];

    filePath = [NSString stringWithFormat:@"%@/%@-Invntry.txt",documentsDirectory,appdelegate.warehousecode];

    stringURL =[NSString stringWithFormat:@"%@%@-Invntry.txt",FILE_URL,appdelegate.warehousecode];
    url = [NSURL URLWithString:stringURL];
    urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        [urlData writeToFile:filePath atomically:YES];
    }

    //--- READ CONTENT FROM customer.txt in Documents DIRECTORY....
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [fileContent componentsSeparatedByString:@"\n"];

    NSLog(@"arr : %@", arr);
   appdelegate.SyncprodArray = [[NSMutableArray alloc] init];

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
            [appdelegate.SyncprodArray  addObject:pitem];
    }

    for(int i=0;i<appdelegate.SyncprodArray.count;i++)
    {
        ProductItem *item =[[ProductItem alloc]init];
        item = [appdelegate.SyncprodArray  objectAtIndex:i];
        //[DBhandle adduserdetails:item user_id:userid];
        [appdelegate.DBhandle adduserdetails:item];
        [appdelegate.DBhandle addproductsdetails:item];
    }
    //[DBhandle deleteStatusWithOne:userid];

    [appdelegate.DBhandle deleteStatusWithOne];
    [appdelegate.DBhandle sync];
    [appdelegate.DBhandle getsynctime];
    
//     [DBhandle sync:userid];
//     [DBhandle getsynctime:userid];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:appdelegate.syncDateTime forKey:@"datetime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  
    appdelegate.syncDateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"datetime"];
    
   
   // NSLog(@"SyncprodArray :%@",appdelegate.SyncprodArray);
    for(int i=0;i<appdelegate.SyncprodArray.count;i++)
    {
        ProductItem *item =[[ProductItem alloc]init];
        item = [appdelegate.SyncprodArray objectAtIndex:i];
        NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,item.productcode];
        if(![fileManager fileExistsAtPath: ImagePath])
        {
            NSLog(@"file :%@ not exists",item.productcode);
            [spinner stopAnimating];
                UIView *view=[self.view viewWithTag:8887];
                [view removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There are Product Photos to be downloaded. Proceed ?" message:@"" delegate:self cancelButtonTitle:@"Proceed" otherButtonTitles:@"Later", nil];
            [alert show];
            break;
            
            
        }
    }
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
        if(isImageDownloadComplete==NO)
        {
       if(isLogout)
       {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:vc animated:YES completion:nil];
       }
        else
        {
            NSLog(@"image downloading");
            [self createSpinnerView];
            [self performSelector:@selector(callImageDownload) withObject:self afterDelay:0.1];
            
        }
        }
    }
    else
    {
        isLogout = NO;
    }
}
-(void)callImageDownload
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    for(int i=0;i<appdelegate.SyncprodArray.count;i++)
    {
        ProductItem *item =[[ProductItem alloc]init];
        item = [appdelegate.SyncprodArray objectAtIndex:i];
        NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,item.productcode];
        UIImage *imagefromServer   = [self getImageFromURL:[NSString stringWithFormat:@"%@%@.jpg",FILE_URL,item.productcode]];
        [UIImageJPEGRepresentation(imagefromServer, 1.0) writeToFile:ImagePath options:NSAtomicWrite error:nil];
    }
    
    [appdelegate.DBhandle sync];
    [appdelegate.DBhandle getsynctime];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
    
    
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
    [spinner stopAnimating];
    UIView *view=[self.view viewWithTag:8887];
    [view removeFromSuperview];
    isImageDownloadComplete = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Images downloaded succesfully" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
@end
