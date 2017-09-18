

请先阅读配文: [《31- 最新环信推送封装 v3.0》](http://www.jianshu.com/p/1eacd5db0299),  比下边的描述更加详细!



# LLHuanXinPushManager
 公司考虑到会做IM客服, 先行推送也采用了环信的. 为了避免重复造轮子, 把这部分抽取出来. 环信推送封装, 环信推送封装, 包括了应用杀死, 应用在前台, 应用挂起三种状态下收到推送消息. 适配iOS8~iOS10!

本次demo的第三方推送是环信, 其他的包括极光推送, 个推 ,只要把官方SDK的推送方法替换环信的推送方法即可.

## 封装效果(更新ing...)
> - 适配iOS8~iOS10和iOS10+
> - 环信登录、注销、自动登录等
> - 使用EBForeNotification，当应用在前台时，iOS8-iOS10也显示推送弾框。
> - UITabBarController+UINavigationController模式, 点击推送消息跳转到执行页面。 当处于指定页面时，再次点击推送消息执行自定义逻辑。
> - 我的项目中，并没有给通知弾框增加Action和附件支持,如果需要的话，可以在下边的**参考**小节中参考另一个demo。
> - 解决了 发了很多推送，App也收到了推送，但是通知栏却只显示最后一条推送 问题
> - 增加清空通知栏所有推送消息的方法  (2017.09.18更新)

![](https://github.com/lilongcnc/LLHuanXinPushManager/blob/master/ScreenShot/screen.gif)

## 运行demo

0. 初次使用开启`debugEnabled`
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

## 接入项目


`LLPushNotificationManager.m`中FIXME 指明了需要替换的文件名称和业务逻.



