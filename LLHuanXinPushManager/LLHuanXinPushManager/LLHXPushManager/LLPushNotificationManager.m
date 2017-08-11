//
//  LLPushNotificationManager.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLPushNotificationManager.h"
#import <UIKit/UIKit.h>
#import "EaseUI.h"
#import "LLPushNotificationUtils.h"
#import "LLPushLoginUtils.h"
#import "EBForeNotification.h"
#import "CustomerTabBarController.h"
#import "ThreeViewController.h"
#import "AppDelegate.h"
#import "WSProgressHUD.h"

//避免宏循环引用
#define LLWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define LLStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

@interface LLPushNotificationManager ()<EMChatManagerDelegate,EMClientDelegate>

@end

@implementation LLPushNotificationManager


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 注册通知/离线通知 ================
//----------------------------------------------------------------------------------------------------------
- (void)ll_registerLocalNotification
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"环信应用标识"];
    
#if DEBUG
    options.apnsCertName = @"自己上传到环信后台的推送证书名称";
#else
    options.apnsCertName = @"自己上传到环信后台的推送证书名称";
#endif
    
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        NSLog(@"进行自动登录...");
    }
    else
    {
        [self ll_huanxinUserlogin];
    }
    
    
    //注册通知,因为需要本地推送,所以没有使用官方文档的推送代码
    [LLPushNotificationUtils ll_registerNotificationWithType:PushNotificationTypeAPNS];
    
    //监听帐号登录情况
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //实时监听推送消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

//---------------------------------------------------------------------------------------------------
#pragma mark ================================== EMClient代理 ==================================
//---------------------------------------------------------------------------------------------------
/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
    
    switch (aConnectionState) {
        case EMConnectionConnected: //已连接
            NSLog(@"SDK连接服务器-已连接");
            break;
        case EMConnectionDisconnected: //未连接
            NSLog(@"SDK连接服务器-未连接");
            break;
            
        default:
            break;
    }
}

/*!
 *  自动登录完成时的回调
 */
- (void)autoLoginDidCompleteWithError:(EMError *)aError {
    NSLog(@"自动登录完成时的回调");
    
    [self addDealMethodsFromUtils];
    
    [self setConfigWhenLoginSuccess];
}


/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{
    NSLog(@"当前登录账号在其它设备登录时会接收到该回调");
    [self ll_huanxinUserloginOut];
    [self removeDelegate];
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer
{
    NSLog(@"当前登录账号已经被从服务器端删除时会收到该回调");
    [self ll_huanxinUserloginOut];
    [self removeDelegate];
    
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 用户点击本地通知时候的回调 ================
//-----------------------------------------------------------------------------------------------------------

//iOS10+ 直接收后台点击事件
- (void)addDealMethodsFromUtils
{
    [LLPushNotificationUtils ll_willPresentNotification:^(UNUserNotificationCenter *center, UNNotification *notification) {
        NSDictionary *userInfo = notification.request.content.userInfo;
        [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }];
    
    
    @LLWeakObj(self);
    [LLPushNotificationUtils ll_didReceiveNotificationResponse:^(UNUserNotificationCenter *center, UNNotificationResponse *response) {
        @LLStrongObj(self);
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        if (userInfo)
        {
            //判断跳转
            NSLog(@"IOS10收到通知");
            [self jumpToTransactionRecordHomeView];
        }
    }];
    
}

// iOS10- 这个方法这里,我们只用来接收后台点击事件
- (void)_didReceiveLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        NSLog(@"ios9收到通知. 用户没点击按钮直接点的推送消息进来的/或者该app在前台状态时收到推送消息");
        NSLog(@"alertBody: %@",notification.alertBody);
        NSLog(@"userInfo: %@",notification.userInfo);
        NSLog(@"soundName: %@",notification.soundName);
        
        [self jumpToTransactionRecordHomeView];
    }
}


//前台自定义通知view点击事件处理
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    [self jumpToTransactionRecordHomeView];
}




- (void)jumpToTransactionRecordHomeView
{
    
//    NSLog(@"------------current------------->%@",self.customerBarVC.navigationController.topViewController);
//    NSLog(@"------------current------------->%@",self.customerBarVC);
//    NSLog(@"------------current------------->%@",self.customerBarVC.selectedViewController);
//    NSLog(@"------------current------------->%@",self.customerBarVC.selectedViewController.childViewControllers);
//    NSLog(@"------------current------------->%@",self.customerBarVC.selectedViewController.childViewControllers);
//    NSLog(@"------------current------------->%@",self.customerBarVC.navigationController.childViewControllers);
//    NSLog(@"------------current------------->%@",self.customerBarVC.navigationController.viewControllers);
    
    //更新数字标识
    [self modifyBadgeNumberByIncrease:NO];
    
    
    //跳转处理
    if (!self.customerBarVC.selectedViewController) {
        return;
    }
    
    
    if ([[self.customerBarVC.selectedViewController.childViewControllers lastObject] isKindOfClass:[ThreeViewController class]]) {
        NSLog(@"");
        ThreeViewController *threeVC = [self.customerBarVC.selectedViewController.childViewControllers lastObject];
        [threeVC refresh];
    }
    else
    {
        ThreeViewController *threeVC = [ThreeViewController new];
        [self.customerBarVC.selectedViewController pushViewController:threeVC animated:YES];
    }
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ EMChatManagerDelegate ================
//-----------------------------------------------------------------------------------------------------------
//监听推送消息  监听环信推送的消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    // 这里注意EBForeNotification和 UIAlertView冲突
    [WSProgressHUD showSuccessWithStatus:@"收到环信通知"];
    NSLog(@"---------------------------------------------------------------------------------->messagesDidReceive: 收到环信通知");
    
//********** 模拟数据
    NSDictionary *dict = @{
                           @"Content" : @{
                                   @"Msg" : @{
                                           @"Type" : @"txt",
                                           @"ObjType" : @"1",
                                           @"Obj" : @{
                                                   @"OName" : @"线下商城",
                                                   @"OID" : @"07101F800001",
                                                   @"EntryTime" : @"2017-07-14 16:03:38.38",
                                                   @"PID" : @"P0C170331162",
                                                   @"InputMoney" : @"209"
                                                   },
                                           @"Msg" : @"您收到一笔成功交易"
                                           },
                                   },
                           @"ReceiverType" : @"1"
                           };
//**********
   
    
    for (EMMessage *message in aMessages) {
        //赋值模拟数据
        message.ext = dict;
        
        //更新消息角标
        [self modifyBadgeNumberByIncrease:YES];
        
        //处理通知事件
        [self dealEMMessageForLocalNotification:message];
    }
    
    
}

- (void)dealEMMessageForLocalNotification:(EMMessage *)message
{
    //判断应用杀死情况下,点击离线推送框启动的app
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.isLaunchedByType == LaunchedAPPByRemoteNotification) {
        appDelegate.isLaunchedByType = LaunchedAPPByDefaultNotification; //还原应用启动状态
        [self jumpToTransactionRecordHomeView];
        return;
    }

    //判断是应用存活时,事件处理
#if !TARGET_IPHONE_SIMULATOR
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    switch (state) {
        case UIApplicationStateActive:
        {
            //发送自定义前台通知
            //EBForeNotification的消息格式是有规范的, 另外内部自定义了通知音效和应用图标,如果需要应用图标,名为:AppIcon60x60,AppIcon80x80
            [EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6还是沈师傅 玩的6"}, @"key1":@"value1", @"key2":@"value2"} soundID:1312];
            
            [self modifyBadgeNumberByIncrease:NO];
            
            [LLPushNotificationUtils ll_playSoundAndVibration]; //提示音和振动
            break;
        }
        case UIApplicationStateInactive:
            [LLPushNotificationUtils ll_playSoundAndVibration]; //提示音和振动
            break;
        case UIApplicationStateBackground:
            [self sendLocalNotification:message];
            break;
        default:
            break;
    }
#endif
}

- (void)sendLocalNotification:(EMMessage *)message
{
    
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
                alertBody = textBody.text;
                NSLog(@"收到的文字是 alertBody -- %@",alertBody);
                
                //取出通知数据
                NSDictionary *contentDict = message.ext[@"Content"];
                NSDictionary *msgDict = contentDict[@"Msg"];
                NSDictionary *ObjDict = msgDict[@"Obj"];
                
                NSString *InputMoneyStr =  ObjDict[@"InputMoney"];
                NSString *MsgStr = msgDict[@"Msg"];
                
                
                //发送消息
                NSLog(@"*****************************************************************UIApplicationStateBackground");
                // 当应用在后台收到本地通知时执行的跳转代码
                NSLog(@"UIApplicationStateBackground");
                [LLPushNotificationUtils ll_sendLocalNotificationWithTitle:MsgStr
                                                                 subTitle:nil
                                                                     body:[NSString stringWithFormat:@"交易金额:%@元",InputMoneyStr]
                                                                    badge:@(-1)
                                                                 userInfo:message.ext
                                                                 complete:^(NSError *error) {
                                                                     if (!error) {
                                                                         
                                                                         
                                                                         NSLog(@"发送本地通知成功");
                                                                     }
                                                                     
                                                                 }];
            }
                break;
            case EMMessageBodyTypeImage:
            case EMMessageBodyTypeLocation:
            case EMMessageBodyTypeVoice:
            case EMMessageBodyTypeVideo:{
                break;
            }
            default:
                break;
        }
    }
}



//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 私有方法 ==================================
//---------------------------------------------------------------------------------------------------
- (void)removeDelegate
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

//处理角标
- (void)modifyBadgeNumberByIncrease:(BOOL)isIncrease{
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (isIncrease)
        badge ++;
    else
        badge --;
    badge = badge? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}


- (void)setConfigWhenLoginSuccess
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] setApnsNickname:@"Lauren"];
        EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
        emoptions.displayStyle = EMPushDisplayStyleMessageSummary; //展示完整推送消息
        EMError *error = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
        
        if(!error) {
            // 成功
            NSLog(@"同步成功");
        }else {
            // 失败
            NSLog(@"同步失败");
        }
    });
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 接口 ================
//-----------------------------------------------------------------------------------------------------------
- (void)ll_didReceiveRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo {
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}


- (void)ll_didReceiveLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification {
    [self _didReceiveLocalNotification:application notification:notification];
}

- (void)ll_applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
}

- (void)ll_applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
}

// 将得到的deviceToken传给SDK
- (void)ll_didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"导入 deviceToken");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    
}

// 注册deviceToken失败
- (void)ll_didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"导入 deviceToken,error -- %@",error);
}

-(void)ll_huanxinUserloginOut
{
    NSLog(@"退出登录");
    [LLPushLoginUtils ll_signOutComplete:^(EMError *error) {
        if (!error) {
            NSLog(@"环信退出登陆成功");
        }
        else
        {
            NSLog(@"环信退出登陆失败");
        }
    }];
    
}


-(void)ll_huanxinUserlogin
{
    NSLog(@"开始登录");
    //登录环信
    //登录帐号公司内部定义
    [LLPushLoginUtils ll_huanxinLoginWithName:@"zhangfei" password:@"111111" complete:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"环信登陆成功");
            
            //设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            //配置个人信息
            [self setConfigWhenLoginSuccess];
            
            //增加回调方法
            [self addDealMethodsFromUtils];
            
        } else {
            NSLog(@"环信登陆失败----->%d----%@",aError.code,aError.errorDescription);
            
            [self removeDelegate];
        }
    }];
    
    
}






@end




/*
 
 EMMessageBody *msgBody = message.body;
 switch (msgBody.type) {
 case EMMessageBodyTypeText:
 {
 // 收到的文字消息
 EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
 NSString *txt = textBody.text;
 NSLog(@"收到的文字是 txt -- %@",txt);
 
 }
 break;
 case EMMessageBodyTypeImage:
 {
 // 得到一个图片消息body
 EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
 NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
 NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
 NSLog(@"大图的secret -- %@"    ,body.secretKey);
 NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
 NSLog(@"大图的下载状态 -- %u",body.downloadStatus);
 
 
 // 缩略图sdk会自动下载
 NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
 NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
 NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
 NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
 NSLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
 }
 break;
 case EMMessageBodyTypeLocation:
 {
 EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
 NSLog(@"纬度-- %f",body.latitude);
 NSLog(@"经度-- %f",body.longitude);
 NSLog(@"地址-- %@",body.address);
 }
 break;
 case EMMessageBodyTypeVoice:
 {
 // 音频sdk会自动下载
 EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
 NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
 NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
 NSLog(@"音频的secret -- %@"        ,body.secretKey);
 NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
 NSLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
 NSLog(@"音频的时间长度 -- %u"      ,body.duration);
 }
 break;
 case EMMessageBodyTypeVideo:
 {
 EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
 
 NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
 NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
 NSLog(@"视频的secret -- %@"        ,body.secretKey);
 NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
 NSLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
 NSLog(@"视频的时间长度 -- %u"      ,body.duration);
 NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
 
 // 缩略图sdk会自动下载
 NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
 NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
 NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
 NSLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
 }
 break;
 case EMMessageBodyTypeFile:
 {
 EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
 NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
 NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
 NSLog(@"文件的secret -- %@"        ,body.secretKey);
 NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
 NSLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
 }
 break;
 
 default:
 break;
 }
 */

