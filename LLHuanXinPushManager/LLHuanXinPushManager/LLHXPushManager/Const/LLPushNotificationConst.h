//
//  LLPushNotificationConst.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

#ifndef LLPushNotificationConst_h
#define LLPushNotificationConst_h

typedef NS_OPTIONS(NSUInteger, PushNotificationType) {
    PushNotificationTypeLocal = 0,//本地推送
    PushNotificationTypeAPNS //APNS 远程推送
    
};




#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d\n%s", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSSimpleLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s %s", __FUNCTION__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil
#define NSSimpleLog(FORMAT, ...) nil

#endif

#endif /* LLPushNotificationConst_h */
