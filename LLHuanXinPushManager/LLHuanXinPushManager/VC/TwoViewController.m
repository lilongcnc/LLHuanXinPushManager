//
//  TwoViewController.m
//  XuanxinPush
//
//  Created by 李龙 on 2017/8/10.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "TwoViewController.h"
#import "AppDelegate.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"第二个页面";
    self.view.backgroundColor = [UIColor  yellowColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
    [button  setTitle:@"登  录" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Applogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 170, 200, 50)];
    [button2  setTitle:@"退  出" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor blueColor]];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(ApploginOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

- (void)Applogin:(id)sender {
    //登录
    NSLog(@"APP登录");
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
#error 登录成功之后,需要调用`ll_registerLocalNotification`方法注册完整通知!否则首次安装应用,首次登录会接收不到推送消息!
    [delegate.pushNotificationManager ll_registerLocalNotification];
}


- (void)ApploginOut:(id)sender {
    NSLog(@"APP退出登录");
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate.pushNotificationManager ll_huanxinUserloginOut];
}
@end
