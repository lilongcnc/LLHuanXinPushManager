//
//  LLTools+Vertify.h
//  MYCategory
//
//  Created by 李龙 on 16/3/15.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLTools.h"

@interface LLTools (Vertify)


/**
 判断对象是否为空
 
 @param object 被判断对象
 @return 结果
 */
+ (BOOL)ll_isEmptyOrNil:(id)object;


/**
 判断字符串是否超过指定位数

 @param string 字符串
 @param length 指定位数
 @return 结果
 */
+ (BOOL)ll_isString:(NSString *)string minLength:(NSInteger)length;


@end
