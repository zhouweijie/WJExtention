//
//  NSString+Hash.h
//  Orbitink
//
//  Created by mmackh on 5/3/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RegexType) {
    RegexTypePhone = 1,
    RegexTypePassword,
    RegexTypeEMail,
    RegexTypeNickName,
    RegexTypeCutImageService,
    RegexTypeContent
};

@interface NSString (Additions)

- (NSString *)urlFriendlyFileNameWithExtension:(NSString *)extension prefixID:(int)prefixID;
- (NSString *)urlFriendlyFileName;
- (NSString *)stringByAppendingURLPathComponent:(NSString *)pathComponent;
- (NSString *)stringByDeletingLastURLPathComponent;

- (NSString *)sha512;
- (NSString *)base64Encode;
- (NSString *)base64Decode;

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;

- (NSString *)stringByStrippingHTML;
- (NSString *)localCachePath;

- (NSString *)trim;
- (BOOL)isNumeric;
- (BOOL)containsString:(NSString *)needle;

__attribute__((overloadable))
NSString *substr(NSString *str, int start);
__attribute__((overloadable))
NSString *substr(NSString *str, int start, int length);

@end

@interface NSObject (isEmpty)

- (BOOL)mag_isEmpty;

@end

@interface NSString (ResetSort)

- (NSDictionary *)URLConvertToDictionary;
- (NSDictionary *)convertToDictionaryUrlComponentsSeparatedByString:(NSString *)separator;
- (NSDictionary *)convertToDictionaryComponentsSeparatedByString:(NSString *)separator;
- (NSString *)customRangeOfString:(NSString *)string separated:(NSString *)separatedByString;

@end


@interface NSString (RegexCategories)

- (BOOL)isMatchForType:(RegexType)type;

@end
