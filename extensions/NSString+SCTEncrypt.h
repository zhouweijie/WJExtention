//
//  NSString+SCTEncrypt.h
//  news
//
//  Created by malei on 2017/11/28.
//  Copyright © 2017年 malei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCTEncrypt)

// url校验码生成
+ (NSDictionary *)SCTEncrypt;
- (NSDictionary *)SCTEncryptChannel;
- (NSString *)SCTEncryptStat;


/**
 解密PHP加密字符（用于解密服务端返回的音频，视频，直播加密id）

 @return 解密字符串
 */
- (NSString *)PHPDecypt;

- (NSString *)PHPEncrypt;

- (NSString *)uriSignWithParams:(NSDictionary *)par;

@end
