//
//  LLPushNotificationUtils.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

/*----------------------------------------------------------------------------------
 *
 *                          本文件是针对本地推送基础功能的封装
 *  tip: 更多本地推送相关的: iOS10推送的action以及 iOS9的推送属性具体使用,请看https://github.com/longitachi/LocalNotification
 *
 ----------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LLPushNotificationPrivate.h"
#import <UserNotifications/UserNotifications.h>
#import "EaseUI.h"


extern NSString * const LLLocalPushNotificationMessageErrorDomain;

typedef void (^sendNotificationCompleteBlock)(NSError *error);
typedef void (^WillPresentNotificationBlock)(UNUserNotificationCenter *center,UNNotification *notification);
typedef void (^DidReceiveNotificationResponseBlock)(UNUserNotificationCenter *center,UNNotificationResponse *response);


@interface LLPushNotificationUtils : NSObject


/**
 注册通知
 
 @param pushNotificationType 通知类型
 */
+ (void)ll_registerNotificationWithType:(PushNotificationType)pushNotificationType;


/**
 发送推送消息
 
 @param title 标题
 @param subTitle 次标题
 @param content 正文
 @param badge 废弃
 @param userInfo userInfo
 @param completeblock 推送完成
 */
+ (void)ll_sendLocalNotificationWithTitle:(NSString *)title
                                 subTitle:(NSString *)subTitle
                                     body:(NSString *)content
                                    badge:(NSNumber *)badge
                                 userInfo:(NSDictionary *)userInfo
                                 complete:(sendNotificationCompleteBlock)completeblock;

/**
 本地推送提示音和振动
 */
+ (void)ll_playSoundAndVibration;


/**
 iOS10 获取到推送消息,优先级>ll_didReceiveNotificationResponse
 */
+ (void)ll_willPresentNotification:(WillPresentNotificationBlock)willPresentNotificationBlock;


/**
 iOS10 推送消息框的点击事件处理
 */
+ (void)ll_didReceiveNotificationResponse:(DidReceiveNotificationResponseBlock)didReceiveNotificationResponseBlock;


//tip:iOS7~iOS0的推送接收方法,在

@end



