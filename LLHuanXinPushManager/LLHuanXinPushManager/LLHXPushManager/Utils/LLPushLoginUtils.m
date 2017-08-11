//
//  LLPushLoginUtils.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLPushLoginUtils.h"
#import <UIKit/UIKit.h>
#import "LLTools+Vertify.h"


void TTAlertNoTitle(NSString* message) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@implementation LLPushLoginUtils
+ (void)ll_huanxinLoginWithName:(NSString *)userName
                       password:(NSString *)password
                       complete:(XuanXinLoginCompleteBlock)complete
{
    
    //检查格式
    [self vertifyFormatWithName:userName password:password];
    
    //请求网络
    [[EMClient sharedClient] loginWithUsername:userName
                                      password:password
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        
                                        if (!aError) {
                                            //回调
                                            !complete ? :complete(aUsername,nil);
                                        }else{
                                            //回调
                                            !complete ? :complete(aUsername,aError);
                                        }
                                        
                                    }];
}




+ (void)ll_huanxinRegisterWithName:(NSString *)userName
                          password:(NSString *)password
                          complete:(XuanXinRegisterCompleteBlock)complete
{
    
    //检查格式
    [self vertifyFormatWithName:userName password:password];
    
    //请求网络
    
    [[EMClient sharedClient] registerWithUsername:userName password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            //回调
            !complete ? :complete(aUsername,nil);
        }else{
            //回调
            !complete ? :complete(aUsername,aError);
            
            switch (aError.code) {
                case EMErrorServerNotReachable:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                    break;
                case EMErrorUserAlreadyExist:
                    TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                    break;
                case EMErrorNetworkUnavailable:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                    break;
                case EMErrorServerTimeout:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                    break;
                case EMErrorServerServingForbidden:
                    TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                    break;
                default:
                    TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                    break;
            }
        }
        
        
    }];
    
}


+ (void)vertifyFormatWithName:(NSString *)userName
                     password:(NSString *)password
{
    if ([LLTools ll_isEmptyOrNil:userName]) {
        NSLog(@"输入的环信用户名为空");
        return ;
    }
    if ([LLTools ll_isEmptyOrNil:password]) {
        NSLog(@"输入的环信注册密码为空");
        return ;
    }
}


+ (void)ll_signOutComplete:(XuanXinSignOutCompleteBlock)complete {
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (!aError) {
            NSLog(@"退出成功");
            !complete ? :complete(nil);
        }
        else
        {
            !complete ? :complete(aError);
        }
        
    }];
}

@end
