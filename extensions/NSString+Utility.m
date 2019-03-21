//
// Created by 周东兴 on 2017/7/31.
// Copyright (c) 2017 JIEMIAN All rights reserved.
//

#import "NSString+Utility.h"


@implementation NSString (Utility)
@dynamic isEmpty,isNotEmpty;
- (BOOL)isEmpty {
    return [self isEqualToString:@""] || [self isEqualToString:@"0"];
}

- (BOOL)isNotEmpty {
    return ![self isEmpty];
}

- (instancetype)overTenThousandProcessingMakeZero:(BOOL)makeZero removeZero:(BOOL)removeZero {
    NSString *newString = @"";
    NSString *pattern = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL result = [predicate evaluateWithObject:self];
    if (result && self.integerValue >= 10000) {
        newString = [NSString stringWithFormat:@"%.1fw",self.integerValue/10000.0];
        double value = fmod(newString.doubleValue, newString.integerValue);
        if (!value) {
            newString = [NSString stringWithFormat:@"%.0fw",self.integerValue/10000.0];
        }
    } else if (result && self.integerValue < 10000){
        if (makeZero) {
            newString = @"";
        } else {
            if (removeZero && [self isEqualToString:@"0"]) {
                newString = @"";
            } else {
                newString = self;
            }
        }
    } else {
        newString = self;
    }
    //去掉2.0w，5.0w这样的形式
    if ([newString containsString:@".0w"]) {
        newString = [NSString stringWithFormat:@"%ldw",newString.integerValue];
    }
    return newString;
}

- (NSInteger)tenThousandChangeToInteger {
    NSInteger count;
    if ([self containsString:@"w"]) {
        double temp = self.doubleValue*10000;
        count = temp;
    } else if ([self isEqualToString:@""]) {
        count = 0;
    } else {
        count = self.integerValue;
    }
    return count;
}

- (instancetype)plusOne
{
    NSInteger count = self.tenThousandChangeToInteger;
    count = count >= 0 ? count : 0;
    count += 1;
    NSString *newCountString = [NSString stringWithFormat:@"%ld",count];
    return [newCountString overTenThousandProcessingMakeZero:false removeZero:true];
}

- (instancetype)minusOne
{
    NSInteger count = self.tenThousandChangeToInteger;
    count -= 1;
    count = count >= 0 ? count : 0;
    NSString *newCountString = [NSString stringWithFormat:@"%ld",count];
    return [newCountString overTenThousandProcessingMakeZero:false removeZero:true];
}

@end
