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

@interface ViewController ()
{
     AppDelegate* appdelegate;
    UIActivityIndicatorView *spinner ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    loginBtn.showsTouchWhenHighlighted = YES;
    
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonImageSelection.png"] forState:UIControlStateSelected];
   
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
               [[NSUserDefaults standardUserDefaults] setValue:custItem.EmailAddr forKey:@"email"];
               [[NSUserDefaults standardUserDefaults] setValue:custItem.CcAddr forKey:@"cc"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              appdelegate.warehousecode = custItem.warehousecode;
              appdelegate.userid = custItem.CustCode;
              appdelegate.emailaddr = custItem.EmailAddr;
              appdelegate.ccaddr = custItem.CcAddr;
              
              [self createSpinnerView];
              [self performSelector:@selector(callFunc) withObject:self afterDelay:0.1];
              break;
          }
     }
    
   if(!isFound)
   {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid username/Password" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
       [alert show];
   }
   
    
    
    
}
-(void)callFunc
{
    [appdelegate getcustProducts];
    
    [spinner stopAnimating];
    UIView *view=[self.view viewWithTag:8887];
    [view removeFromSuperview];
    
    
    CartViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self presentViewController:cv animated:YES completion:nil];
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
