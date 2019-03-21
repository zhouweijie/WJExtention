//
//  UIImage+JM.h
//  news
//
//  Created by 朱晓峰 on 2018/8/10.
//  Copyright © 2018年 malei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JM)

+ (UIImage *)jmNews_animatedGIFNamed:(NSString *)name;

+ (UIImage *)jmNews_animatedGIFWithData:(NSData *)data;

- (UIImage *)jmNews_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
