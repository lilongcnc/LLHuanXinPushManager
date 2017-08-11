//
//  LLSystemPlayUtils.h
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

/*----------------------------------------------------------------
 *                          手机播放音效和振动                       *
 -----------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface LLSystemPlayUtils : NSObject



/**
 播放音效
 */
+ (SystemSoundID)ll_playSoundWithURL:(NSURL *)audioPath;


/**
 手机振动
 */
+ (void)ll_playVibration;


@end
