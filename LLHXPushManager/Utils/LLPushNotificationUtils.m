//
//  LLPushNotificationUtils.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLPushNotificationUtils.h"
#import "LLTools+Vertify.h"
#import "AppDelegate.h"
#import "LLSystemPlayUtils.h"


NSString * const LLLocalPushNotificationMessageErrorDomain = @"LLLocalPushNotificationMessageErrorDomain";

@interface LLPushNotificationUtils ()<UNUserNotificationCenterDelegate>

@property (nonatomic,assign) PushNotificationType pushNotificationType;
@property (nonatomic,copy) DidReceiveNotificationResponseBlock myDidReceiveNotificationResponseBlock;
@property (nonatomic,copy) WillPresentNotificationBlock myWillPresentNotificationBlock;


@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation LLPushNotificationUtils

+ (LLPushNotificationUtils *)shareInstnce
{
    static dispatch_once_t onceToken;
    static LLPushNotificationUtils *presenter;
    dispatch_once(&onceToken, ^{
        presenter = [LLPushNotificationUtils new];
    });
    return presenter;
}





//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 注册本地通知 ================
//----------------------------------------------------------------------------------------------------------

+ (void)ll_registerNotificationWithType:(PushNotificationType)pushNotificationType {
    
    [self shareInstnce].pushNotificationType = pushNotificationType;
    [[self shareInstnce] registerLocalNotification];
}

- (void)registerLocalNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //也可以通过if (NSClassFromString(@"UNUserNotificationCenter"))判断
        [self registeriOS10LocalNotification];
    } else {
        [self registerBelowiOS10LocalNotification];
    }
}



- (void)registeriOS10LocalNotification
{
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;// 必须写代理，不然无法监听通知的接收与点击
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert
                                             | UNAuthorizationOptionBadge
                                             | UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //用户点击允许
                                  LLLog(@"🐳🐳🐳🐳🐳🐳🐳 -%s- 注册通知成功",__func__);
                                  
                                  //获取当前的通知设置
                                  [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                                  }];
                                  
                                  
                                  if (_pushNotificationType == PushNotificationTypeAPNS) {
                                      // 注册APNS远程推送
#if !TARGET_IPHONE_SIMULATOR  // 因为需要获取 deviceTolen,真机才有,所以判断是不是模拟器上
                                      //iOS10 注册APNS
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
                                  }
                                  
                                  
                              } else {
                                  //用户点击不允许
                                  LLLog(@"🐳🐳🐳🐳🐳🐳🐳 -%s- iOS10 注册通知失败",__func__);
                              }
                          }];
}


- (void)registerBelowiOS10LocalNotification
{
    //创建消息上面要添加的动作（iOS9才支持）
    //......
    
    
    if([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
        //[[UIDevice currentDevice].systemVersion doubleValue] >= 8.0
    {
        // 1.注册UserNotification,以获取推送通知的权限
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
        if (_pushNotificationType == PushNotificationTypeAPNS)
        {
            // 注册APNS远程推送
#if !TARGET_IPHONE_SIMULATOR // 因为需要获取 deviceTolen,真机才有,所以判断是不是模拟器上
            // iOS8 注册APNS
            [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
        }
    }
    else
    {
#if !TARGET_IPHONE_SIMULATOR
        // 小于iOS8 注册APNS
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
#endif
    }
    
}




//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 发送本地通知 ==================================
//---------------------------------------------------------------------------------------------------
+ (void)ll_sendLocalNotificationWithTitle:(NSString *)title
                                 subTitle:(NSString *)subTitle
                                     body:(NSString *)content
                                    badge:(NSNumber *)badge
                                 userInfo:(NSDictionary *)userInfo
                                 complete:(sendNotificationCompleteBlock)completeblock
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [[self shareInstnce] sendLocalNotificationAboveiOS10WithTitle:title subTitle:subTitle body:content badge:badge userInfo:userInfo complete:completeblock];
    } else {
        [[self shareInstnce] sendLocalNotificationBelowiOS10WithTitle:title subTitle:subTitle body:content badge:badge  userInfo:userInfo complete:completeblock];
    }
}


#define kLocalNotificationKey @"kLocalNotificationKey"

- (void)sendLocalNotificationAboveiOS10WithTitle:(NSString *)title
                                        subTitle:(NSString *)subTitle
                                            body:(NSString *)content
                                           badge:(NSNumber *)badge
                                        userInfo:(NSDictionary *)userInfo
                                        complete:(sendNotificationCompleteBlock)completeblock
{
    
    if ([LLTools ll_isEmptyOrNil:content]) {
        //alertBody为nil或者空字符串时候，不会显示
        !completeblock? : completeblock([NSError errorWithDomain:LLLocalPushNotificationMessageErrorDomain code:-1 userInfo:@{@"errorMessage":@"content为空！"}]);
        return;
    }
    
    
    UNMutableNotificationContent *nContent = [[UNMutableNotificationContent alloc] init];
    //推送文字信息
    if (![LLTools ll_isEmptyOrNil:title]) {
        nContent.title = title;
    }
    if (![LLTools ll_isEmptyOrNil:subTitle]) {
        nContent.subtitle = subTitle;
        
    }
    nContent.body = content;
    nContent.userInfo = userInfo;
    nContent.sound = [UNNotificationSound soundNamed:@"unbelievable.caf"];
    
    //推送附件,根据需求自行定义
    //nContent.attachments = @[UNNotificationAttachment];
    
    //推送方式
    //UNTimeIntervalNotificationTrigger
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
    
    //发送推送
#error 这个标识很重要,如果唯一不变的话,那么我们在通知中心和锁屏状态下,通知栏只显示一条推送, 后收到的推送把前一条推送顶掉.  更改这个标识,则不会被挤掉.
    NSString *requestIdentifier = [NSString stringWithFormat:@"requestIdentifier_%d",arc4random_uniform(1000)];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:nContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        LLLog(@"🐳🐳🐳🐳🐳🐳🐳 -%s- iOS 10 发送推送， error：%@", __func__,error);
        !completeblock? : completeblock(error);
    }];
}

- (void)sendLocalNotificationBelowiOS10WithTitle:(NSString *)title
                                        subTitle:(NSString *)subTitle
                                            body:(NSString *)content
                                           badge:(NSNumber *)badge
                                        userInfo:(NSDictionary *)userInfo
                                        complete:(sendNotificationCompleteBlock)completeblock
{
    
    if ([LLTools ll_isEmptyOrNil:content]) {
        //alertBody为nil或者空字符串时候，不会显示
        !completeblock? : completeblock([NSError errorWithDomain:LLLocalPushNotificationMessageErrorDomain code:-1 userInfo:@{@"errorMessage":@"content为空！"}]);
        return;
    }
    
    // 1.创建一个本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的一些属性(通知发出的时间/通知的内容)
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.f];
    // 2.2.设置通知的内容
    localNote.alertBody = content;
    // 2.3.设置锁屏界面的文字
    localNote.alertAction = @"查看订单详情";
    // 2.4.设置锁屏界面alertAction是否有效
    localNote.hasAction = YES;
    // 2.5.设置通过点击通知打开APP的时候的启动图片(无论字符串设置成什么内容,都是显示应用程序的启动图片)
    //    localNote.alertLaunchImage = @"111";
    // 2.6.设置通知中心通知的标题
    if (![LLTools ll_isEmptyOrNil:title]) {
        localNote.alertTitle = title;
    }
    // 2.7.设置音效
    localNote.soundName = @"unbelievable.caf";
    // 2.8.设置应用程序图标右上角的数字
    //    if ([badge integerValue] > 0) {
    //        localNote.applicationIconBadgeNumber = [badge integerValue];
    //    }
    // 2.9.设置通知之后的属性
    localNote.userInfo = userInfo;
    // 2.10 时区
    //    localNote.timeZone = [NSTimeZone defaultTimeZone];
    // 2.11 设置重复的间隔
    //    localNote.repeatInterval = kCFCalendarUnitSecond;
    
    
    //想要告知的通知参数
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNote];//scheduleLocalNotification
    
    //回调
    !completeblock? : completeblock(nil);
}



//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 接口 ==================================
//---------------------------------------------------------------------------------------------------
+ (void)ll_didReceiveNotificationResponse:(DidReceiveNotificationResponseBlock)didReceiveNotificationResponseBlock{
    [self shareInstnce].myDidReceiveNotificationResponseBlock = didReceiveNotificationResponseBlock;
}

+ (void)ll_willPresentNotification:(WillPresentNotificationBlock)willPresentNotificationBlock{
    [self shareInstnce].myWillPresentNotificationBlock = willPresentNotificationBlock;
}


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 10.0; //kDefaultPlaySoundInterval这里没有使用,如果需要指定一段时间内接收到通知没有音效,可以在环信官方 Demo 中搜索kDefaultPlaySoundInterval
+ (void)ll_playSoundAndVibration{
    // 收到消息时，播放音频(EBForeNotification中也有音效,这里不保留音效,若要使用,只要禁止EBForeNotification音效,补上音效名称即可)
    // 音效文件: xxxx.caf
//    [LLSystemPlayUtils ll_playSoundWithURL:[[NSBundle mainBundle] URLForResource:@"xxxx" withExtension:@"caf"]];
    
    [LLSystemPlayUtils ll_playVibration];// 收到消息时，震动
}


//清空未展示的通知
+ (void)cleanLocalNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}




//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ UNUserNotificationCenterDelegate iOS10及之后接收通知 ================
//-----------------------------------------------------------------------------------------------------------
/**
 本地和远程推送合为一个，通过 response.notification.request.trigger 来区分
 1.UNPushNotificationTrigger （远程通知） 远程推送的通知类型
 
 2.UNTimeIntervalNotificationTrigger （本地通知） 一定时间之后，重复或者不重复推送通知。我们可以设置timeInterval（时间间隔）和repeats（是否重复）。
 
 3.UNCalendarNotificationTrigger（本地通知） 一定日期之后，重复或者不重复推送通知 例如，你每天8点推送一个通知，只要dateComponents为8，如果你想每天8点都推送这个通知，只要repeats为YES就可以了。
 
 4.UNLocationNotificationTrigger （本地通知）地理位置的一种通知，
 当用户进入或离开一个地理区域来通知。在CLRegion标识符必须是唯一的。因为如果相同的标识符来标识不同区域的UNNotificationRequests，会导致不确定的行为。
 */

/*
 willPresentNotification: 接收到通知的事件,//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
 
 -(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
 //1. 处理通知
 
 //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
 completionHandler(UNNotificationPresentationOptionAlert);
 }
 
 */
#pragma mark - iOS10 接收推送的两个方法
//通知的接收事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    !self.myWillPresentNotificationBlock ? :self.myWillPresentNotificationBlock(center,notification);
}


//通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    !self.myDidReceiveNotificationResponseBlock? : self.myDidReceiveNotificationResponseBlock(center,response);
    completionHandler();
}







@end
