//
//  AppDelegate+LLHuanxinPushRegister.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/19.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "AppDelegate+LLHuanxinPushRegister.h"
#import <objc/runtime.h>
#import "LLPushNotificationPrivate.h"


#define ll_IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


@implementation AppDelegate (LLHuanxinPushRegister)

+(void)load
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳🐳🐳 - %s",__FUNCTION__);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class obj = [self class];
        
        classSwizzleInstanceMethod(obj, @selector(application:didFinishLaunchingWithOptions:), @selector(ll_application:didFinishLaunchingWithOptions:));
        classSwizzleInstanceMethod(obj, @selector(applicationDidEnterBackground:), @selector(ll_applicationDidEnterBackground:));
        classSwizzleInstanceMethod(obj, @selector(applicationWillEnterForeground:), @selector(ll_applicationWillEnterForeground:));
        
        classSwizzleInstanceMethod(obj, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), @selector(ll_application:didRegisterForRemoteNotificationsWithDeviceToken:));
        classSwizzleInstanceMethod(obj, @selector(application:didFailToRegisterForRemoteNotificationsWithError:), @selector(ll_application:didFailToRegisterForRemoteNotificationsWithError:));
    
    
        if (!ll_IOS10_OR_LATER)
        {
            classSwizzleInstanceMethod(obj, @selector(application:didReceiveRemoteNotification:), @selector(ll_application:didReceiveRemoteNotification:));
            classSwizzleInstanceMethod(obj, @selector(application:didReceiveLocalNotification:), @selector(ll_application:didReceiveLocalNotification:));
        }
    
    });
    
}


- (BOOL)ll_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳🐳🐳 - %s",__FUNCTION__);
    self.isLaunchedByType = LaunchedAPPByDefaultNotification; //正常启动
    //注册推送
    [self regisPushPresenter:application];
    
    if(launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        self.isLaunchedByType = LaunchedAPPByRemoteNotification; //远程通知启动
    }

    return [self ll_application:application didFinishLaunchingWithOptions:launchOptions]; //注意这里不要return YES;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 应用启动方法 ================
//-----------------------------------------------------------------------------------------------------------
// APP进入后台
- (void)ll_applicationDidEnterBackground:(UIApplication *)application
{
    [self.pushNotificationManager ll_applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)ll_applicationWillEnterForeground:(UIApplication *)application
{
    [self.pushNotificationManager ll_applicationWillEnterForeground:application];
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 通知相关注册 ================
//-----------------------------------------------------------------------------------------------------------
// 将得到的deviceToken传给SDK
- (void)ll_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [self.pushNotificationManager ll_didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)ll_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [self.pushNotificationManager ll_didFailToRegisterForRemoteNotificationsWithError:error];
}


// (iOS10之前)本地通知回调函数，当应用程序在前台时调用
- (void)ll_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.pushNotificationManager ll_didReceiveLocalNotification:application notification:notification];
}

// (iOS10之前)远程通知回调函数
- (void)ll_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self.pushNotificationManager ll_didReceiveRemoteNotification:application userInfo:userInfo];
}



#pragma mark ================ 私有方法 ================
// 注册推送对象
- (void)regisPushPresenter:(UIApplication *)application{
    self.pushNotificationManager = [LLPushNotificationManager new];
    [self.pushNotificationManager  ll_registerLocalNotification];
    
}


BOOL classSwizzleInstanceMethod(Class obj, SEL originalSel, SEL swizzleSel)
{
    
    Method originalMethod = class_getInstanceMethod(obj, originalSel);
    Method swizzleMethod = class_getInstanceMethod(obj, swizzleSel);
    
    if (!originalMethod)
    {
        class_addMethod(obj, originalSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        method_setImplementation(swizzleMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    else
    {
        BOOL didAddMethod = class_addMethod(obj, originalSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (didAddMethod)
        {
            class_replaceMethod(obj, swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else
        {
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    }
    
    return YES;
}



@end
