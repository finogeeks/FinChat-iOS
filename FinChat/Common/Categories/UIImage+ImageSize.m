//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/FINQRCode.git
//
//  UIImage+FINHelper.m
//  FINQRCodeExample
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "UIImage+ImageSize.h"

#define FINQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define FINQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation UIImage (ImageSize)

/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = FINQRCodeScreenWidth;
    CGFloat screenHeight = FINQRCodeScreenHeight;
    
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

