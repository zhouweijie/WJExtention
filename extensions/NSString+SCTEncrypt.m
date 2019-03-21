//
//  NSString+SCTEncrypt.m
//  news
//
//  Created by malei on 2017/11/28.
//  Copyright © 2017年 malei. All rights reserved.
//

#import "NSString+SCTEncrypt.h"
#import "JMUtility.h"
#import "JiemianUserManager.h"
#import "NSString+Additions.h"

static NSString * kPHPDecryptKey = @"a234*&a1sds3xcxc";

@implementation NSString (SCTEncrypt)

// POST请求参数加密方式
+ (NSDictionary *)SCTEncrypt
{
    /*
     sct (用来校验的加密串)
     code (每次生成的一个4位随机字符串)
     
     客户端 sct 生成规则：
     1.客户端内置一个PIN： 3RGKVDSa8I12kIAhZtsi8p123T2ULi53
     2.生成一个新的字符串 s = md5(sid + PIN + code)
     3.把s的第 1, 6, 3, 11, 17, 9, 21, 27位字符拿出来，按照这个顺序拼成 sct
     */
    NSString *pin = kSCTPINKey;
    NSString *code = [self createRandomCode]; // 生成随机字符串
    NSString *sid = @"";
    // 获取sid
    JiemianUserManager *userManager = [JiemianUserManager shareInstance];
    if ([userManager checkIsLogin]) {
        sid = userManager.user.userSid;
    }
    // md5生成32位字符串
    NSString *md5Str = [JMUtility md5Hash:[NSString stringWithFormat:@"%@%@%@", sid, pin, code]];
    // 根据规则提取不同的字符
    NSString *mStr = [NSString rangString:md5Str];
    // 返回生成后的校验码
    NSDictionary *sctDic = @{
                             @"code": code,
                             @"sct": [NSString stringWithString:mStr]
                             };
    
    return sctDic;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// 频道加密方式
- (NSDictionary *)SCTEncryptChannel
{
    return [self SCTEncryptWithString:self pinKey:kSCTPINKey codeKeyName:@"rand" sctKeyName:@"stat_pin"];
}

// 广告跟踪加密方式
- (NSString *)SCTEncryptStat
{
    NSDictionary *dict = [self SCTEncryptWithString:self pinKey:kPHPStatCryptKey codeKeyName:@"code" sctKeyName:@"sct" useCode:NO];
    return dict[@"sct"];
}

// 广告跟踪加密方式
- (NSString *)PHPEncrypt
{
    return [self PHPEncryptWithStr:self];
}

// 新接口oapi加密方式
- (NSString *)uriSignWithParams:(NSDictionary *)par
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"uid="];
    [urlString appendString:par[@"uid"] ?: @""];
    [urlString appendString:@"D1568EFB8EAE4651D16C5CC5F0ED29411A234050"];
    NSString *md5String = [JMUtility md5Hash:urlString];
    NSString *sign = [NSString rangString:md5String];
    return sign;
}

#pragma mark - Private function
- (NSDictionary *)SCTEncryptWithString:(NSString *)str
                                pinKey:(NSString *)pinkey
                           codeKeyName:(NSString *)codeName
                            sctKeyName:(NSString *)sctName
{
    return [self SCTEncryptWithString:str pinKey:pinkey codeKeyName:codeName sctKeyName:sctName useCode:YES];
}

- (NSDictionary *)SCTEncryptWithString:(NSString *)str
                                pinKey:(NSString *)pinkey
                           codeKeyName:(NSString *)codeName
                            sctKeyName:(NSString *)sctName
                               useCode:(BOOL)useCode
{
    /*
     stat_pin (用来校验的加密串)
     rand (每次生成的一个4位随机字符串)
     
     客户端 sct 生成规则：
     1.客户端内置一个PIN： 3RGKVDSa8I12kIAhZtsi8p123T2ULi53
     2.生成一个新的字符串 s = md5(string + rand + PIN)
     3.把s的第 1, 6, 3, 11, 17, 9, 21, 27位字符拿出来，按照这个顺序拼成 sct
     */
    //    str = @"m=stat&a=app&id=33|331&wid=23|2211&position=AKAIJI&deviceid=6eadc9f537435da3c453f028ada5d54a&uid=100000038&devicetype=iphone";
    //    str = @"a=app&deviceid=6eadc9f537435da3c453f028ada5d54a&devicetype=iphone&id=33|331&m=stat&position=AKAIJI&uid=100000038&wid=23|2211";
    NSString *string = CHANGE_TO_STRING(str);
    NSString *pin = pinkey;
    NSString *rand = @"";
    NSString *md5Str = @"";
    
    if (useCode) {
        // md5生成32位字符串
        rand = [NSString createRandomCode];
        md5Str = [JMUtility md5Hash:[NSString stringWithFormat:@"%@%@%@", string, rand, pin]];
    } else {
        md5Str = [JMUtility md5Hash:[NSString stringWithFormat:@"%@%@", string, pin]];
    }
    
    // 根据规则提取不同的字符
    NSString *mStr = [NSString rangString:md5Str];
    
    // 返回生成后的校验码
    return  @{
              codeName: rand,
              sctName: [NSString stringWithString:mStr]
              };
}

+ (NSString *)createRandomCode
{
    NSString *rand = @"";
    NSUInteger maxCodeLength = 4; // 4位随机
    
    // 生成随机字符串
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    if (uniqueId.length > maxCodeLength) {
        rand = [uniqueId substringWithRange:NSMakeRange(0, maxCodeLength)];
    }
    CFRelease(uuidStringRef);
    return rand;
}

- (NSString *)PHPDecypt {
    return [self PHPDecyptWithKey:kPHPDecryptKey toBase64:YES];
}

- (NSString *)PHPDecyptWithKey:(NSString *)key toBase64:(BOOL)toBase64{
    NSString *str = self;
    // 判断是否基于base64解码
    if (toBase64) {
        //替换字符
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        
        // 此方法与加密调用的方法一致
        str = [self edWithStr:[str base64Decode] key:key];
    }
    else {
        str = [self edWithStr:str key:key];
    }
    // 解码后得到的明文
    NSString *v = @"";
    
    // 密文的长度
    NSUInteger len = str.length;
    
    for (int i = 0; i < len; i++) {
        // 将前一个密文的相邻字符进行 ^ 运算
        NSString *md5 = [str substringWithRange:NSMakeRange(i, 1)];
        i++;
        if (i >= len) {
            continue;
        }
        NSString *pinStr = [self pinxCreator:[str substringWithRange:NSMakeRange(i, 1)] withPinv:md5];
        
        // 组装明文
        v = [v stringByAppendingFormat:@"%@", pinStr];
    }
    
    return v;
}

- (NSString *)PHPEncryptWithStr:(NSString *)str
{
    NSString *key = kPHPDecryptKey;
    
    NSString *r = [JMUtility md5Hash:key];
    int c = 0;
    NSString *v = @"";
    NSUInteger len = str.length;
    NSUInteger l = r.length;
    for (int i = 0; i < len; i++) {
        if (c==l) c = 0;
        
        NSString *rRangeStr = [r substringWithRange:NSMakeRange(c, 1)];
        NSString *strRangeStr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *pinStr = [self pinxCreator:strRangeStr withPinv:rRangeStr];
        
        v = [v stringByAppendingFormat:@"%@%@", rRangeStr, pinStr];
        c ++;
    }
    
    NSString *edV = [self edWithStr:v key:key];
    //NSData *data = [[NSData alloc] initWithBytes:[edV UTF8String] length:edV.length];
    NSString *baseV = [edV base64Encode];//= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    baseV = [baseV stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    baseV = [baseV stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    baseV = [baseV stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    baseV = [baseV stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return baseV;
}

- (NSString *)edWithStr:(NSString *)str key:(NSString *)key
{
    NSString *r = [JMUtility md5Hash:key];
    int c = 0;
    NSString *v = @"";
    NSUInteger len = str.length;
    NSUInteger l = r.length;
    for (int i = 0; i < len; i++) {
        if (c==l) c = 0;
        NSString *strRangeStr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *rRangeStr = [r substringWithRange:NSMakeRange(c, 1)];
        NSString *pinStr = [self pinxCreator:strRangeStr withPinv:rRangeStr];
        
        v = [v stringByAppendingString:pinStr];
        c ++;
    }
    return v;
}

- (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length) {
        return nil;
    }
    
    NSString *temp = @"";
    
    for (int i = 0; i < pan.length; i++) {
        int panValue = [pan characterAtIndex:i];
        int pinvValue = [pinv characterAtIndex:i];
        
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%C",(unichar)(panValue^pinvValue)]];
    }
    return temp;
}

+ (NSString *)rangString:(NSString *)str
{
    // 根据规则提取不同的字符
    NSMutableString *mStr = [@"" mutableCopy];
    if (str.length > 0) {
        NSArray *rangeArr = [self rangeArray];
        for (NSNumber *n in rangeArr) {
            [mStr appendFormat:@"%@", [str substringWithRange:NSMakeRange([n integerValue], 1)]];
        }
    }
    return mStr;
}

+ (NSArray *)rangeArray
{
    return @[@(0), @(5), @(2), @(10), @(16), @(8), @(20), @(26)];
}

@end
