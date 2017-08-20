//
//  AppDelegate.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/3.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseUI.h"
#import "WSProgressHUD.h"
#import "CustomerTabBarController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"🐷🐷🐷🐷🐷🐷***************************************************************%s",__FUNCTION__);

    //这里是你自己的工程代码
    _baseTabBarController = [[CustomerTabBarController alloc]init];
    [_baseTabBarController setSelectedIndex:0];
    self.window.rootViewController = _baseTabBarController;
    [self.window makeKeyAndVisible];

    //FIXME:需要告诉管理器根控制器!!!
    self.pushNotificationManager.customerBarVC = _baseTabBarController;
    self.pushNotificationManager.debugEnabled = NO; //开启 log 输出,默认为 NO
    
    return YES;
}




- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
