//
//  UIImage+Implementation.h
//  FinoChat
//
//  Created by 杨涛 on 2017/11/2.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Implementation)

//通过颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color;
//给图片添加背景，返回图片
+ (UIImage *)imageFromImageName:(NSString *)imageName color:(UIColor *)color withFrame:(CGRect)frame;
//截屏生成图片
+ (UIImage *)imageFromUIView:(UIView *)aView;
//返回一个绽放到newSize可以放下的image
+ (UIImage *)scaledCopyOfSize:(CGSize)newSize image:(UIImage *)image;
//从上到下拼出图片，在最后加上水印
+ (UIImage *)mergeImagesData:(NSArray *)imagesDatas logo:(UIImage *)logo;
//从上到下拼出图片，在最后加上水印
+ (UIImage *)mergeImages:(NSArray *)images logo:(UIImage *)logo;
//从image中心开始扩散截取viewsize的区域
+ (UIImage *)image:(UIImage *)image centerInSize:(CGSize)viewsize;
//获取圆角图像
+ (UIImage *)getRoundImageFromImage:(UIImage *)image withFrame:(CGSize)size withRadius:(CGFloat)radius;
//图片转换成数据格式
+ (NSData *)dataFromImage:(UIImage *)image;
//压缩图片数据大小
+ (UIImage *)imageFromOriginalImage:(UIImage *)originalImage purposeSize:(CGFloat)byte;
//等比缩放图片
+ (UIImage *)cropEqualScaleFromOriginalImage:(UIImage *) originalImage ToSize:(CGSize)size;
//固定尺寸缩放，可能存在图片拉伸
+ (UIImage *)cropEqualScaleFromOriginalImage:(UIImage *)originalImage ToFixedSize:(CGSize)size;
//生成一张高斯模糊的图片   blur  模糊程度 (0~1)
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;


@end
