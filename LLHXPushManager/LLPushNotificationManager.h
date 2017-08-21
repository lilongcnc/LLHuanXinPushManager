//
//  LLPushNotificationManager.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LLPushNotificationUtils.h"
#import "LLPushNotificationPrivate.h"

@class CustomerTabBarController;

@interface LLPushNotificationManager : NSObject

@property (nonatomic,strong) CustomerTabBarController *customerBarVC;

//注册铜活字
- (void)ll_registerLocalNotification;

// 环信注册配置接口
- (void)ll_applicationDidEnterBackground:(UIApplication *)application;
- (void)ll_applicationWillEnterForeground:(UIApplication *)application;
- (void)ll_didReceiveLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification;
- (void)ll_didReceiveRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo;
- (void)ll_didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)ll_didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


/**
 是否打印 log
 */
@property (nonatomic,assign) BOOL debugEnabled;


//注册和登录接口已经内部处理,不推荐外部调用
-(void)ll_huanxinUserloginOut LLDeprecated("不推荐外部调用此方法,内部已经处理");
-(void)ll_huanxinUserlogin LLDeprecated("不推荐外部调用此方法,内部已经处理");


@end
