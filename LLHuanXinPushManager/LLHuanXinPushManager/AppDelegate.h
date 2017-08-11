//
//  AppDelegate.h
//  XuanxinPush
//
//  Created by 李龙 on 2017/8/3.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPushNotificationManager.h"

typedef NS_OPTIONS(NSUInteger, LaunchedAPPByType) {
    LaunchedAPPByRemoteNotification = 0,
    LaunchedAPPByLocalNotification,
    LaunchedAPPByDefaultNotification
};

@class CustomerTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) LLPushNotificationManager *pushNotificationManager;
@property (nonatomic,strong) CustomerTabBarController *baseTabBarController;
@property (nonatomic,assign) LaunchedAPPByType isLaunchedByType;

@end

