//
//  LLPushNotificationManager.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LLPushNotificationUtils.h"
@class CustomerTabBarController;

@interface LLPushNotificationManager : NSObject

@property (nonatomic,strong) CustomerTabBarController *customerBarVC;

- (void)ll_registerLocalNotification;

/**
 APP进入后台
 */
- (void)ll_applicationDidEnterBackground:(UIApplication *)application;

/**
 APP将要从后台返回
 */
- (void)ll_applicationWillEnterForeground:(UIApplication *)application;

- (void)ll_didReceiveLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification;



- (void)ll_didReceiveRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo;





- (void)ll_didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

// 注册deviceToken失败
- (void)ll_didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;



/**
 退出环信账户
 */
-(void)ll_huanxinUserloginOut;


/**
 登录环信账户
 */
-(void)ll_huanxinUserlogin;


@end
