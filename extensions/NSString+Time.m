//
//  NSString+time.m
//  news
//
//  Created by xiaopzi on 17/1/22.
//  Copyright © 2017年 malei. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)


+ (NSString *)stringBySecond_HMS:(CGFloat)duration
{
    /**
     时：分：秒。
     当出现“时”时，“分”、“秒”的单位必展示（如为0，请写00）；
     当出现“秒”时，“分”的单位必展示（如为0,请写00）；
     当“分”的单位为0时，不需要出现“时”的单位。如下：
     01：00：00
     02：55
     00：55
     冒号为英文模式
     */
    NSUInteger dHours = floor(duration / 3600);
    NSUInteger dMinutes = floor((NSUInteger)duration%3600/60);
    NSUInteger dSeconds = floor((NSUInteger)duration%3600%60);
    
    if (dHours > 0) {
        return [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    } else {
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    }
    
    return nil;
}

+ (NSString *)formatTimeWithDateByJieMian:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM'/'dd' 'HH':'mm'"];
    NSString *strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)stringBySecond_MS:(CGFloat)duration
{
    /*
     分：秒
     目前最大支持 999：59（超过后不能正确显示）
     **/
    NSUInteger dHours = floor(duration / 3600);
    NSUInteger dMinutes = floor((NSUInteger)duration%3600/60 + dHours*60);
    NSUInteger dSeconds = floor((NSUInteger)duration%3600%60);
    if (dMinutes > 99) {
        return [NSString stringWithFormat:@"%03lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    } else {
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    }
    return nil;
}

+ (NSString *)formatRelativeTime:(NSDate *)date {
    NSTimeInterval elapsed = [date timeIntervalSinceNow];
    
    if (elapsed < 0) {
        elapsed = -elapsed;
    }
    
    if (elapsed < TT_MINUTE) {
        return @"刚刚";
        
    } else if (elapsed < TT_HOUR) {
        int mins = (int)(elapsed/TT_MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", mins];
        
    } else if (elapsed < TT_DAY) {
        int hours = (int)(elapsed/TT_HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    } else if (elapsed < TT_MONTH) {
        int days = (int)(elapsed/TT_DAY);
        return [NSString stringWithFormat:@"%d天前", days];
        
    } else if (elapsed < TT_YEAR) {
        int months = (int)(elapsed/TT_MONTH);
        return [NSString stringWithFormat:@"%d个月前", months];
        
    } else {
        int years = (int)(elapsed/TT_YEAR);
        return [NSString stringWithFormat:@"%d年前", years];
    }
    
    return @"刚刚";
}

+ (NSString *)calculateTimeInterval:(NSString *)timeIntervalStr {
    NSDate *pulishDate = [NSDate dateWithTimeIntervalSince1970:[timeIntervalStr doubleValue]];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:pulishDate];
    NSInteger timeCount = 0;
    
    NSString *timeStr;
    
    if (timeInterval < 60) {
        // xx秒前
        timeStr = @"刚刚";
    }
    else if (timeInterval < 60 * 60) {
        // xx分钟前
        timeCount = timeInterval / 60;
        timeStr = [NSString stringWithFormat:@"%li分钟前", (long)timeCount];
    }
    else if (timeInterval < 60 * 60 * 24) {
        // xx小时前
        timeCount = timeInterval / (60 * 60);
        timeStr = [NSString stringWithFormat:@"%li小时前", (long)timeCount];
    }
    else if (timeInterval < 60 * 60 * 24 * 30) {
        // xx天前
        timeCount = timeInterval / (60 * 60 * 24);
        timeStr = [NSString stringWithFormat:@"%li天前", (long)timeCount];
    }
    else if (timeInterval < 60 * 60 * 24 * 30 * 12) {
        // xx月前
        timeCount = timeInterval / (60 * 60 * 24 * 30);
        timeStr = [NSString stringWithFormat:@"%li个月前", (long)timeCount];
    }
    else {
        // xx年
        timeCount = timeInterval / (60 * 60 * 24 * 30 * 12);
        timeStr = [NSString stringWithFormat:@"%li年前", (long)timeCount];
    }
    
    return timeStr;
}

+ (NSString *)stringBySecond:(CGFloat)duration
{
    /**
     时：分：秒。
     1：00：00
     5：04：13
     02：55
     00：55
     冒号为英文模式
     */
    NSUInteger dHours = floor(duration / 3600);
    NSUInteger dMinutes = floor((NSUInteger)duration%3600/60);
    NSUInteger dSeconds = floor((NSUInteger)duration%3600%60);
    
    if (dHours > 0) {
        return [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    } else {
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    }
    
    return nil;
}

+ (NSString *)formatStartTime:(NSString *)time
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日  HH:mm"];
    return [dateFormatter stringFromDate: startDate];
}

+ (NSString *)currentTime
{
    return [NSString stringWithFormat:@"%ld", time(NULL)];
}

@end
