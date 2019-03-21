//
//  NSData+AESAdditions.h
//  news
//
//  Created by xiaopzi on 17/1/20.
//  Copyright © 2017年 malei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESAdditions)

- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end
