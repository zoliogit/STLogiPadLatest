//
//  ProdDescViewController.m
//  STLogiPad
//
//  Created by Sreekumar A N on 8/25/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "ProdDescViewController.h"
#import "AppDelegate.h"
#import "ProductItem.h"

@interface ProdDescViewController ()

@end

@implementation ProdDescViewController
{
    AppDelegate* appdelegate;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   backBtn.showsTouchWhenHighlighted = YES;
    
    [favbtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   favbtn.showsTouchWhenHighlighted = YES;
    
    [delBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   delBtn.showsTouchWhenHighlighted = YES;
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
    addBtn.showsTouchWhenHighlighted = YES;
    
    Isdelete = YES;
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Pcode.text = [NSString stringWithFormat:@"Product Code: %@",appdelegate.SelectedpItem.productcode];
  
    uom.text = [NSString stringWithFormat:@"UOM : %@",appdelegate.SelectedpItem.productuom];
    Pdesc.text = appdelegate.SelectedpItem.proddescription;
    
    if(appdelegate.isFromQR)
     qtyLabel.text = [NSString stringWithFormat:@"%d", appdelegate.SelectedpItem.QRQuantity];
    else
    qtyLabel.text = [NSString stringWithFormat:@"%d", appdelegate.SelectedpItem.quantity];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *ImagePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,appdelegate.SelectedpItem.productcode];
    UIImage *image = [UIImage imageWithContentsOfFile:ImagePath];
    if(image == nil)
        image = [UIImage imageNamed:@"no-image.png"];
    
   Pimage.image = image;
    
    if(appdelegate.cartArray.count>0)
    {
        for(int i=0;i<appdelegate.cartArray.count;i++)
        {
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem = [appdelegate.cartArray objectAtIndex:i];
            if([appdelegate.SelectedpItem.productcode isEqualToString:pitem.productcode])
            {
                [addBtn setTitle:@"Update" forState:UIControlStateNormal];
                delBtn.hidden = NO;
            }
            else
               addBtn.hidden = NO;
            
        }
    }
    
    if(appdelegate.favArray.count >0)
    {
        for(int i=0;i<appdelegate.favArray.count;i++)
        {
            
            ProductItem *pitem = [[ProductItem alloc] init];
            pitem = [appdelegate.favArray objectAtIndex:i];
            if([appdelegate.SelectedpItem.productcode isEqualToString:pitem.productcode])
            {
               favbtn.hidden = YES;
            }
            else
                favbtn.hidden = NO;
            
        }
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backBtnPressed:(id)sender
{
    backBtn.selected = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)DelBtnPressed:(id)sender {
    
     delBtn.selected = YES;
    
            Isdelete = NO;
           [appdelegate.DBhandle deletefromcart:appdelegate.SelectedpItem userid:appdelegate.userid];
    
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully deleted from cart" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
    
 
    
}
- (IBAction)PlusPressed:(id)sender {
     if([qtyLabel.text integerValue] >= 0)
        qtyLabel.text = [NSString stringWithFormat:@"%ld", [qtyLabel.text integerValue] + 1];
}

- (IBAction)MinusPressed:(id)sender {
    
    if([qtyLabel.text integerValue] == 1 && delBtn.hidden == NO)
    {
        Isdelete = YES;
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@""
                            message:@"Do you want to delete the product from cart"
                            delegate:self
                            cancelButtonTitle:@"YES"
                            otherButtonTitles:@"NO", nil];
        [tmp show];
    }
    else
    {
    if([qtyLabel.text integerValue] >1)
        qtyLabel.text = [NSString stringWithFormat:@"%ld", [qtyLabel.text integerValue] - 1];
    }
}

- (IBAction)AddToCartPressed:(id)sender {
    
     addBtn.selected = YES;
    Isdelete = NO;
    
    appdelegate.SelectedpItem.quantity =[qtyLabel.text intValue];
    
    UIButton *someButton = (UIButton*)sender;
    NSString * strButtonTitle = [someButton titleForState:UIControlStateSelected];
    if([strButtonTitle isEqualToString:@"Update"])
    {
    [appdelegate.DBhandle updatecart:appdelegate.SelectedpItem userid:appdelegate.userid];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully Updated" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
        
    }
    else
    {
       BOOL isadded = [appdelegate.DBhandle addToCart:appdelegate.SelectedpItem userid:appdelegate.userid];
       if(isadded)
       {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully added to cart" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
       }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    if (buttonIndex==0) {
        
        if(Isdelete == YES)
        {
        
        for(int i=0;i<appdelegate.cartArray.count;i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict = [appdelegate.cartArray objectAtIndex:i];
            if([appdelegate.SelectedpItem.productcode isEqualToString:[dict objectForKey:@"ProductCode"]])
            {
                [appdelegate.cartArray removeObjectAtIndex:i];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully deleted from cart" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    }
}

- (IBAction)FavPressed:(id)sender {
    
     favbtn.selected = YES;
    Isdelete = NO;
    appdelegate.SelectedpItem.quantity = [qtyLabel.text intValue];
    [appdelegate.DBhandle addToFav:appdelegate.SelectedpItem userid:appdelegate.userid];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully added to favourites" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    
}
@end
