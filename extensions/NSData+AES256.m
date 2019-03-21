//
//  NSData+AES256.m
//  news
//
//  Created by xiaopzi on 17/1/20.
//  Copyright © 2017年 malei. All rights reserved.
//

#import "NSData+AES256.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "GTMBase64.h"

//#define PASSWORD @"8xtmTy8PK4QPmVscyb2Tcw=="

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
//const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

//static Byte saltBuff[] = {0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF};

//static Byte ivBuff[]   = {0xA,1,0xB,5,4,0xF,7,9,0x17,3,1,6,8,0xC,0xD,91};

@implementation NSData (AES256)

//+ (NSData *)AESKeyForPassword:(NSString *)password{                  //Derive a key from a text password/passphrase
//
//    NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
//
//    NSData *salt = [NSData dataWithBytes:saltBuff length:kCCKeySizeAES128];
//
//    int result = CCKeyDerivationPBKDF(kCCPBKDF2,        // algorithm算法
//                                      password.UTF8String,  // password密码
//                                      password.length,      // passwordLength密码的长度
//                                      salt.bytes,           // salt内容
//                                      salt.length,          // saltLen长度
//                                      kCCPRFHmacAlgSHA1,    // PRF
//                                      kPBKDFRounds,         // rounds循环次数
//                                      derivedKey.mutableBytes, // derivedKey
//                                      derivedKey.length);   // derivedKeyLen derive:出自
//
//    NSAssert(result == kCCSuccess,
//             @"Unable to create AES key for spassword: %d", result);
//    return derivedKey;
//}
//
///*加密方法*/
//+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey {
//    NSData *plainText = [plain dataUsingEncoding:NSUTF8StringEncoding];
//    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
//    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
//    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
//
//    NSUInteger dataLength = [plainText length];
//
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    bzero(buffer, sizeof(buffer));
//
//    size_t numBytesEncrypted = 0;
//
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
//                                          [[NSData AESKeyForPassword:aeskey] bytes], kCCKeySizeAES256,
//                                          ivBuff /* initialization vector (optional) */,
//                                          [plainText bytes], dataLength, /* input */
//                                          buffer, bufferSize, /* output */
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//        return [encryptData base64EncodedStringWithOptions:kNilOptions];
//    }
//
//    free(buffer); //free the buffer;
//    return nil;
//}
//
///*解密方法*/
//+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts  AESKey:(NSString *)aeskey {
//    NSData *cipherData = [NSData dataWithBase64EncodedString:ciphertexts];
//    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
//    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
//    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
//
//    NSUInteger dataLength = [cipherData length];
//
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//
//    size_t numBytesDecrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
//                                          [[NSData AESKeyForPassword:aeskey] bytes], kCCKeySizeAES256,
//                                          ivBuff ,/* initialization vector (optional) */
//                                          [cipherData bytes], dataLength, /* input */
//                                          buffer, bufferSize, /* output */
//                                          &numBytesDecrypted);
//
//    if (cryptStatus == kCCSuccess) {
//        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
//        return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
//    }
//
//    free(buffer); //free the buffer;
//    return nil;
//}
//
///*加密方法*/
////(key和iv向量这里是16位的) 这里是CBC加密模式，安全性更高
//+ (NSString *)AES128EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey gIv:(NSString *)Iv {
//    //将nsstring转化为nsdata
//    NSData *data = [plain dataUsingEncoding:NSUTF8StringEncoding];
//
//    char keyPtr[kCCKeySizeAES128+1];
//    bzero(keyPtr, sizeof(keyPtr));
//    [aeskey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//
//    char ivPtr[kCCKeySizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//
//    NSUInteger dataLength = [data length];
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmAES128,
//                                          kCCOptionPKCS7Padding,
//                                          keyPtr,
//                                          kCCBlockSizeAES128,
//                                          ivPtr,
//                                          [data bytes],
//                                          dataLength,
//                                          buffer,
//                                          bufferSize,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *bufferData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//        //返回进行base64进行转码的加密字符串
//        NSData *base64Data = [GTMBase64 encodeData:bufferData];
//        return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
//    }
//    free(buffer);
//    return nil;
//}

//解密方法
+ (NSString *)AES128DecryptWithCiphertext:(NSString *)ciphertexts AESKey:(NSString *)aeskey gIv:(NSString *)Iv {
    //将nsstring转化为nsdata
    NSData *decodeBase64Data = [GTMBase64 decodeString:ciphertexts];
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [aeskey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [decodeBase64Data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [decodeBase64Data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *decryData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        //将解了密码的nsdata转化为nsstring
        return [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

+ (id)dataWithBase64EncodedString:(NSString *)string;
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@""];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end
