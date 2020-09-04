//
//  UIImage+Fino.m
//  FinChat
//
//  Created by 杨涛 on 2018/2/28.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "UIImage+Fino.h"

@implementation UIImage(Fino)
+ (UIImage *)fin_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end

