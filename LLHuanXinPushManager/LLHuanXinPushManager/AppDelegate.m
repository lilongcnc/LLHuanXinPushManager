//
//  AppDelegate.m
//  PushDemo
//
//  Created by 赵广亮 on 2016/11/16.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
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
    
    _isLaunchedByType = LaunchedAPPByDefaultNotification; //正常启动
    
    _baseTabBarController = [[CustomerTabBarController alloc]init];
    [_baseTabBarController setSelectedIndex:0];
    self.window.rootViewController = _baseTabBarController;
    [self.window makeKeyAndVisible];
    
    //注册推送
    [self regisPushPresenter:application];
    
    if(launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        _isLaunchedByType = LaunchedAPPByRemoteNotification; //远程通知启动
    }
    
    return YES;
}






//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 推送相关专属方法 ==================================
//---------------------------------------------------------------------------------------------------
- (void)regisPushPresenter:(UIApplication *)application{
    _pushNotificationManager = [LLPushNotificationManager new];
    _pushNotificationManager.customerBarVC =  _baseTabBarController;
    [_pushNotificationManager  ll_registerLocalNotification];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_pushNotificationManager ll_applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_pushNotificationManager ll_applicationWillEnterForeground:application];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [_pushNotificationManager ll_didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [_pushNotificationManager ll_didFailToRegisterForRemoteNotificationsWithError:error];
}

// (iOS9及之前)本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [_pushNotificationManager ll_didReceiveLocalNotification:application notification:notification];
}


//?????????
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [_pushNotificationManager ll_didReceiveRemoteNotification:application userInfo:userInfo];

}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 其他方法 ================
//-----------------------------------------------------------------------------------------------------------
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
