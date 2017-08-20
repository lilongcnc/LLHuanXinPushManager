//
//  LLPushNotificationPrivate.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/20.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLPushNotificationPrivate.h"



void LLLog(NSString *format, ...) {
#ifdef DEBUG
    if (![LLPushNotificationPrivate shareInstance].debugEnabled) {
        return;
    }
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}


@implementation LLPushNotificationPrivate

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static LLPushNotificationPrivate *obj;
    dispatch_once(&onceToken, ^{
       obj = [LLPushNotificationPrivate new];
    });
    
    return obj;
}

@end
