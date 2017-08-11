//
//  LLTools+Vertify.m
//  MYCategory
//
//  Created by 李龙 on 16/3/15.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLTools+Vertify.h"

@implementation LLTools (Vertify)

+ (BOOL)ll_isEmptyOrNil:(id)object {
    if (object == nil || object == [NSNull null]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)object;
        if (string.length == 0) {
            return YES;
        }
        return NO;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)object;
        return number.integerValue == 0;
    }
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        return array.count == 0;
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionry = (NSDictionary *)object;
        return dictionry.allKeys.count == 0;
    }
    if ([object isKindOfClass:[NSSet class]]) {
        NSSet *set = (NSSet *)object;
        return set.anyObject == nil;
    }
    if ([object isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)object;
        return date == nil;
    }
    
    return YES;
}



+ (BOOL)ll_isString:(NSString *)string minLength:(NSInteger)length {
    if (string == nil || ![string respondsToSelector:@selector(length)]) {
        return NO;
    }
    if (((NSString *)string).length < length) {
        return NO;
    }
    return YES;
}



@end
