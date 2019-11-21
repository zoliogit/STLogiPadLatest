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

@interface orderDetailsViewController ()
{
    AppDelegate *appdelegate;
}

@end

@implementation orderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
   backBtn.showsTouchWhenHighlighted = YES;
    
    [ReorderBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
    ReorderBtn.showsTouchWhenHighlighted = YES;
    
     appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view.
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
    
    for (int i=0;i< appdelegate.orderDetailsArray.count ; i++)
    {
        
        ProductItem *pitem = [[ProductItem alloc] init];
        pitem = [appdelegate.orderDetailsArray objectAtIndex:i];
        [appdelegate.DBhandle addToCart:pitem userid:appdelegate.userid];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product successfully added to cart" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    CartViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self presentViewController:cv animated:YES completion:nil];
    
    
    
}
@end
