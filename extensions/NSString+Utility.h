//
// Created by 周东兴 on 2017/7/31.
// Copyright (c) 2017 JIEMIAN All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
@property(nonatomic, assign) BOOL isEmpty;

@property(nonatomic, assign) BOOL isNotEmpty;


/**
 字符串过万处理，如果超过一万返回带一位小数的字符串，例：“13.6w“，带有w不处理

 @param makeZero YES:没有过万返回空字符串：@"",NO:没有过万不做处理
 @param removeZero YES:如果是@"0",返回@""，NO:不处理
 @return 处理过的字符串
 */
- (instancetype)overTenThousandProcessingMakeZero:(BOOL)makeZero removeZero:(BOOL)removeZero;

///将包含‘w'的字符串转换成NSUIInteger
- (NSInteger)tenThousandChangeToInteger;
///加一之后再返回字符串，过万则加"w"
- (instancetype)plusOne;
///减一之后返回字符串，如果是 @“0” 则返回 @“”，传@“0”再调这方法，返回@“”
- (instancetype)minusOne;

@end
