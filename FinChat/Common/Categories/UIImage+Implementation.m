//
//  UIImage+Implementation.m
//  FinoChat
//
//  Created by 杨涛 on 2017/11/2.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//
#import "UIImage+Implementation.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Implementation)

+ (UIImage *)imageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 200, 200);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (UIImage *)imageFromImageName:(NSString *)imageName color:(UIColor *)color withFrame:(CGRect)frame{
    
    float scale = [[UIScreen mainScreen] scale];
    
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect rect = CGRectMake(0, 0, scale*frame.size.width, scale*frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    [image drawInRect:CGRectMake((scale*frame.size.width - scale*image.size.width )/2, (scale*frame.size.height - scale*image.size.height )/2, scale*image.size.width, scale*image.size.height)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromUIView:(UIView *)aView {
    CGSize pageSize = aView.frame.size;
    UIGraphicsBeginImageContext(pageSize);
    
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:resizedContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)scaledCopyOfSize:(CGSize)newSize image:(UIImage *)image
{
    CGImageRef imgRef = [image CGImage];
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > newSize.width || height > newSize.height) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+ (UIImage *)mergeImagesData:(NSArray *)imagesDatas logo:(UIImage *)logo {
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for (NSData *data in imagesDatas) {
        UIImage *img = [UIImage imageWithData:data];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.6);
        UIImage *_img = [UIImage imageWithData:imgData];
        [ar addObject:_img];
    }
    return [UIImage mergeImages:ar logo:logo];
}
+ (UIImage *)mergeImages:(NSArray *)images logo:(UIImage *)logo {
    
    if (!images || [images count] <= 0) return nil;
    int maxWidth = 0;
    int maxHeiht = 0;
    
    for ( UIImage *image in images) {
        float iWidth = CGImageGetWidth([image CGImage]);
        float iHeight = CGImageGetHeight([image CGImage]);
        maxWidth = MAX(maxWidth, iWidth);
        maxHeiht += iHeight;
    }
    
    CGRect cropRect = CGRectMake(0.0, 0.0, maxWidth, maxHeiht);
    
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    [[UIColor whiteColor] set];
    CGContextFillRect(ctx, cropRect);
    //
    int lastY = 0;
    for ( UIImage *img in images) {
        
        float iWidth = CGImageGetWidth([img CGImage]);
        float iHeight = CGImageGetHeight([img CGImage]);
        
        CGRect drawRect = CGRectMake(0.0, lastY , iWidth, iHeight);
        CGContextDrawImage(ctx, drawRect, img.CGImage);
        lastY += iHeight;
    }
    
    // draw the logo on the merge image.
    if (logo) {
        CGRect drawRect = CGRectMake(0.0, 0.0 , CGImageGetWidth([logo CGImage]), CGImageGetHeight([logo CGImage]));
        CGContextDrawImage(ctx, drawRect, logo.CGImage);
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)image:(UIImage *)image centerInSize:(CGSize)viewsize
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(viewsize);
    float dwidth = (viewsize.width - size.width)/2.0f;
    float dheight = (viewsize.height - size.height)/2.0f;
    CGRect rect = CGRectMake(dwidth,dheight,size.width,size.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
+ (UIImage *)getRoundImageFromImage:(UIImage *)image withFrame:(CGSize)size withRadius:(CGFloat)radius{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius] addClip];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage.copy;
}


+ (NSData *)dataFromImage:(UIImage *)image {
    NSData *data = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    return data.copy;
}

+ (UIImage *)imageFromOriginalImage:(UIImage *)originalImage purposeSize:(CGFloat)byte {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = [self dataFromImage:originalImage];
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    while ([imageData length] > byte && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(compressedImage, compression);
        compressedImage = [UIImage imageWithData:imageData];
    }
    return compressedImage;
}

+ (UIImage *)cropEqualScaleFromOriginalImage:(UIImage *) originalImage ToSize:(CGSize)size {
    
    CGFloat scale =  [UIScreen mainScreen].scale;
    // 这一行至关重要
    // 不要直接使用UIGraphicsBeginImageContext(size);方法
    // 因为控件的frame与像素是有倍数关系的
    // 比如@1x、@2x、@3x图，因此我们必须要指定scale，否则黄色去不了,图片存在缩放现象
    // 因为在5以上，scale为2，6plus scale为3，所生成的图是要合苹果的规格才能正常
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGSize aspectFitSize = CGSizeZero;
    if (originalImage.size.width != 0 && originalImage.size.height != 0) {
        CGFloat rateWidth = size.width / originalImage.size.width;
        CGFloat rateHeight = size.height / originalImage.size.height;
        //以宽高值小的为准，设置称为比例系数
        CGFloat rate = MIN(rateHeight, rateWidth);
        aspectFitSize = CGSizeMake(originalImage.size.width * rate, originalImage.size.height * rate);
    }
    [originalImage drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 非等比缩放，生成的图片可能会被拉伸
+ (UIImage *)cropEqualScaleFromOriginalImage:(UIImage *)originalImage ToFixedSize:(CGSize)size  {
    CGFloat scale =  [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;
{
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
