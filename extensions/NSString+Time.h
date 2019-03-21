//
//  NSString+time.h
//  news
//
//  Created by xiaopzi on 17/1/22.
//  Copyright © 2017年 malei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

+ (NSString *)stringBySecond_HMS:(CGFloat)duration;
+ (NSString *)formatTimeWithDateByJieMian:(NSDate *)date;
+ (NSString *)stringBySecond_MS:(CGFloat)duration;
+ (NSString *)formatRelativeTime:(NSDate *)date;
/**
 格式化时间戳
 @param timeIntervalStr 时间戳
 */
+ (NSString *)calculateTimeInterval:(NSString *)timeIntervalStr;
+ (NSString *)stringBySecond:(CGFloat)duration;
+ (NSString *)formatStartTime:(NSString *)time;
+ (NSString *)currentTime;

@end
