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


typedef void (^ll_huanxinUserloginSuccess) ();
typedef void (^ll_huanxinUserloginFailure) ();

typedef void (^ll_huanxinUserloginOutSuccess) ();
typedef void (^ll_huanxinUserloginOutFailure) ();
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



/**
 在 app 退出登录的时候调用
 */
-(void)ll_huanxinUserloginOut;


/**
 在 app 登录的时候调用
 */
-(void)ll_huanxinUserlogin;


-(void)ll_huanxinUserloginSuccess:(ll_huanxinUserloginSuccess)success failure:(ll_huanxinUserloginFailure)failure;
-(void)ll_huanxinUserloginOutSuccess:(ll_huanxinUserloginOutSuccess)success failure:(ll_huanxinUserloginOutFailure)failure;

@end
