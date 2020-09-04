//
//  FCUIHelper.h
//  FinoChatSDK
//
//  Created by Six on 30/10/2017.
//  Copyright © 2017 finogeeks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCUIHelper : NSObject

+ (instancetype)sharedInstance;

@end


@interface FCUIHelper (Device)

+ (BOOL)isIPad;
+ (BOOL)isIPadPro;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
//+ (BOOL)isASimulator;

+ (BOOL)is58InchScreen;
+ (BOOL)is55InchScreen;
+ (BOOL)is47InchScreen;
+ (BOOL)is40InchScreen;
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

/// 判断当前设备是否高性能设备，只会判断一次，以后都直接读取结果，所以没有性能问题
+ (BOOL)isHighPerformanceDevice;

+ (UIImage *)fin_imageWithTintColor:(UIColor *)tintColor image:(UIImage *)image;

+ (UIViewController *)fin_topViewController:(UIViewController *)rootViewController;
@end

