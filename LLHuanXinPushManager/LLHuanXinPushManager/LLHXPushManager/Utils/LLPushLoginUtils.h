//
//  LLPushLoginUtils.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//
/*----------------------------------------------------------------
              环信聊天的登录,必须登录才能接收到推送                     *
 -----------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "EaseUI.h"

typedef void (^XuanXinRegisterCompleteBlock)(NSString *aUsername, EMError *aError);
typedef void (^XuanXinLoginCompleteBlock)(NSString *aUsername, EMError *aError);
typedef void (^XuanXinSignOutCompleteBlock)(EMError *error);

@interface LLPushLoginUtils : NSObject
/**
 环信用户登录
 */
+ (void)ll_huanxinLoginWithName:(NSString *)userName
                       password:(NSString *)password
                       complete:(XuanXinLoginCompleteBlock)complete;


/**
 环信注册
 */
+ (void)ll_huanxinRegisterWithName:(NSString *)userName
                          password:(NSString *)password
                          complete:(XuanXinRegisterCompleteBlock)complete;


/**
 环信退出登录
 */
+ (void)ll_signOutComplete:(XuanXinSignOutCompleteBlock)complete;

@end
