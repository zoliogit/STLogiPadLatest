//
//  OrderStatusViewController.m
//  STLogiPad
//
//  Created by Sreekumar A N on 9/27/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import "OrderStatusViewController.h"
#import "OrderStatusTableViewCell.h"
#import "AppDelegate.h"
#import "orderDetailsViewController.h"

@interface OrderStatusViewController ()
{
   AppDelegate* appdelegate;
    
}

@end

@implementation OrderStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    
    backbtn.showsTouchWhenHighlighted = YES;
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdelegate.DBhandle getOrderstatus:appdelegate.userid];
    NSLog(@"app:%@",appdelegate.orderArray);
    
//    NSMutableDictionary *ordDict1 = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *ordDict2 = [[NSMutableDictionary alloc]init];
//    [ordDict1 setValue:@"27-09-2019" forKey:@"Date"];//001140030
//    [ordDict1 setValue:@"3:30 PM" forKey:@"Time"];
//    [ordDict1 setValue:@"5" forKey:@"NoItems"];
//    [ordDict1 setValue:@"Submitted" forKey:@"Status"];
//
//    [ordDict2 setValue:@"26-09-2019" forKey:@"Date"];
//    [ordDict2 setValue:@"10:00 AM" forKey:@"Time"];
//    [ordDict2 setValue:@"10" forKey:@"NoItems"];
//    [ordDict2 setValue:@"Submitted" forKey:@"Status"];
//
//
//    [orderArray addObject:ordDict1];
//    [orderArray addObject:ordDict2];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.orderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"OrderStatusTableViewCell";
    OrderStatusTableViewCell *cell = (OrderStatusTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];//dequeing cell from tableview. And if it is nil, initialize new cell instance
    if (cell == nil){
        
        cell = [[OrderStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderStatusTableViewCell"];
    }
    if( [indexPath row] % 2){
        cell.backgroundColor=[UIColor whiteColor];
        
    }
    else
    {
        cell.backgroundColor=[UIColor lightGrayColor];
    }
        
                              //colorWithRed:28.0f/255 green:175.0f/255 blue:135.0f/255 alpha:1.0f];}
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [appdelegate.orderArray objectAtIndex:indexPath.row];
    cell.SlNo.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    NSString *dateTime = [dict objectForKey:@"date"];
    NSArray *seperateString = [dateTime componentsSeparatedByString:@" "];
   
    NSArray *seperateTimeString = [seperateString[1] componentsSeparatedByString:@":"];
    cell.Date.text =  seperateString[0];
    cell.time.text = [NSString stringWithFormat:@"%@:%@ %@",seperateTimeString [0],seperateTimeString[1],seperateString[2]];
    cell.NoOfItems.text = [dict objectForKey:@"itemcount"];
    cell.Status.text = [dict objectForKey:@"status"];
   
    
    return cell;
    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [appdelegate.orderArray objectAtIndex:indexPath.row];
    [appdelegate.DBhandle getOrderdetails:[[dict objectForKey:@"orderid"] integerValue]];
    orderDetailsViewController *odv = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDetailsViewController"];
    [self presentViewController:odv animated:YES completion:nil];
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

- (IBAction)BackBtnPressed:(id)sender {
    
    backbtn.selected = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
