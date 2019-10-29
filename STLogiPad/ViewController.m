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
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonImageSelection.png"] forState:UIControlStateSelected];
   
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LoginPressed:(id)sender {
    
     appdelegate.islogin = YES;
    loginBtn.selected = YES;
     [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"login"];
     [[NSUserDefaults standardUserDefaults] setValue:_username.text forKey:@"username"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
    
    appdelegate.userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
   
    [self createSpinnerView];
    [self performSelector:@selector(callFunc) withObject:self afterDelay:0.1];
    
    
    
}
-(void)callFunc
{
    [appdelegate getcustProducts];
    
    
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
