

配文地址: [《31- 最新环信推送封装 v3.0》](http://www.jianshu.com/p/1eacd5db0299)



# LLHuanXinPushManager
 环信推送封装, 完整包括了APNS 推送, 应用在前台推送, 应用在后台时推送.  iOS10- 和 iOS10+ 均显示推送弹框!


###封装效果
> - 适配iOS8~iOS10和iOS10+
> - 环信登录、注销、自动登录等
> - 使用EBForeNotification，当应用在前台时，iOS8-iOS10也显示推送弾框。
> - UITabBarController+UINavigationController模式, 点击推送消息跳转到执行页面。 当处于指定页面时，再次点击推送消息执行自定义逻辑。
> - 我的项目中，并没有给通知弾框增加Action和附件支持,如果需要的话，可以在下边的**参考**小节中参考另一个demo。

![效果图](http://upload-images.jianshu.io/upload_images/594219-57f10fac0a60e33d.gif?imageMogr2/auto-orient/strip)


###运行demo
1. `LLPushNotificationManager.m`中指定环信应用标识：
   
         EMOptions *options = [EMOptions optionsWithAppkey:@"环信应用标识"];

2. `LLPushNotificationManager.m`中指定上传到环信后台的推送证书名称：

        #if DEBUG
            options.apnsCertName = @"自己上传到环信后台的推送证书名称";
        #else
            options.apnsCertName = @"自己上传到环信后台的推送证书名称";
        #endif
 
3. `LLPushNotificationManager.m`中指定IM账户：
    
        ll_huanxinLoginWithName:@"lisi" password:@"123456"
        
4. 首次进入应用，需要`账户`页面，点击登录。和应用的正常使用逻辑相同。关于环信的自动登录接口定义，在环信API中可查。
