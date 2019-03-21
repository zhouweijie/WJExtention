//
//  NSData+AES256.h
//  news
//
//  Created by xiaopzi on 17/1/20.
//  Copyright © 2017年 malei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

//+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey;        /*加密方法,参数需要加密的内容*/
//+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts  AESKey:(NSString *)aeskey; /*解密方法，参数数密文*/
//+ (NSString *)AES128EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey gIv:(NSString *)Iv;
+ (NSString *)AES128DecryptWithCiphertext:(NSString *)ciphertexts  AESKey:(NSString *)aeskey gIv:(NSString *)Iv; /*解密方法，参数数密文*/

@end
