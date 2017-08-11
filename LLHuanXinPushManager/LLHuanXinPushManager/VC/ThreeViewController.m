//
//  ThreeViewController.m
//  XuanxinPush
//
//  Created by 李龙 on 2017/8/10.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "ThreeViewController.h"
#import "WSProgressHUD.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"第三个页面";
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (void)refresh {
    [WSProgressHUD showSuccessWithStatus:@"第三个页面刷新数据和页面"];
    NSLog(@"第三个页面刷新数据和页面");
}

@end
