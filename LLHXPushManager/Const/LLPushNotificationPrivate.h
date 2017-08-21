//
//  LLPushNotificationPrivate.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/20.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, PushNotificationType) {
    PushNotificationTypeLocal = 0,//本地推送
    PushNotificationTypeAPNS //APNS 远程推送
    
};


// 过期提醒
#define LLDeprecated(instead) NS_DEPRECATED(0.1, 0.1, 0.1, 0.1, instead)

FOUNDATION_EXPORT void LLLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);



@interface LLPushNotificationPrivate : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign) BOOL debugEnabled;



@end
