//
//  ViewController.m
//  LGOIN DEMO
//
//  Created by icd-zhanghaiyang on 17/2/28.
//  Copyright © 2017年 Proxy_OuYang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createLogoutButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)createLogoutButton
{
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    logoutButton.frame = CGRectMake(self.view.center.x - 40, self.view.center.y - 15, 80, 30);
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(actionOnLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoutButton];
}

- (void)actionOnLogoutButton:(UIButton *)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setWindowRootViewWithStringType: @"Logout"];
}


@end
