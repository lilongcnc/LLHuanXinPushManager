//
//  OneViewController.m
//  XuanxinPush
//
//  Created by 李龙 on 2017/8/10.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "OneViewController.h"
#import "ThreeViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"第一个页面";
    self.view.backgroundColor = [UIColor  redColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
    [button  setTitle:@"跳转到第三页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(pushToVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)pushToVC
{
    ThreeViewController *threeVC= [ThreeViewController new];
    [self.navigationController pushViewController:threeVC animated:YES];
}


@end
