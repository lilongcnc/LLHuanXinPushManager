
//
//  CustomerTabBarController.m
//  Weijin
//
//  Created by 李龙 on 17/08/06.
//  Copyright (c) 2015年 HuanXinPush. All rights reserved.
//

#import "CustomerTabBarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"

#define DColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@interface CustomerTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CustomerTabBarController


- (instancetype)init
{
    if (self = [super init])
    {
        OneViewController *oneVC = [[OneViewController alloc] init];
        [self addOneChildController:oneVC title:@"首页" norImage:@"dianpu-hui.png" selectedImage:@"dianpu-h" addTag:0];
        

        TwoViewController *twoVC = [[TwoViewController alloc]init];
        [self addOneChildController:twoVC title:@"账户" norImage:@"main_account" selectedImage:@"main_accountSelect" addTag:3];
        
        self.delegate = self;
    }
    return self;
}

- (void)addOneChildController:(UIViewController *)childVc title:(NSString *)title norImage:(NSString *)norImage selectedImage:(NSString *)selectedImage addTag:(NSInteger)tag{
    // 自定义titile的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DColor(169, 169, 169), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor =  DColor(72, 171, 239);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:norImage];
    childVc.tabBarItem.tag=tag;
    
    UIImage *selImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selImage;
    
    UINavigationController  *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [nav.navigationBar setBackgroundColor:[UIColor lightGrayColor]];
    [self addChildViewController:nav];
 
}


@end
