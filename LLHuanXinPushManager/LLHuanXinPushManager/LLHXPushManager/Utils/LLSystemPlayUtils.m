//
//  LLSystemPlayUtils.m
//  LLHuanXinPushManager
//
//  Created by 李龙 on 2017/8/11.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLSystemPlayUtils.h"
void EMSystemSoundFinishedPlayingCallback222(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}


@implementation LLSystemPlayUtils

#pragma mark -播放音乐
+ (SystemSoundID)ll_playSoundWithURL:(NSURL *)audioPath
{
    // Path for the audio file
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(soundID,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          EMSystemSoundFinishedPlayingCallback222, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(soundID);
    
    return soundID;
}


+ (void)ll_playVibration
{
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          EMSystemSoundFinishedPlayingCallback222, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
