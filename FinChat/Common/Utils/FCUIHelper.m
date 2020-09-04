//
//  FCUIHelper.m
//  FinoChatSDK
//
//  Created by Six on 30/10/2017.
//  Copyright © 2017 finogeeks.com. All rights reserved.
//

#import "FCUIHelper.h"
#import "FCUICommonDefines.h"

@implementation FCUIHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FCUIHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

@end

@implementation FCUIHelper (Device)

static NSInteger isIPad = -1;
+ (BOOL)isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器，改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPadPro = -1;
+ (BOOL)isIPadPro {
    if (isIPadPro < 0) {
        isIPadPro = [FCUIHelper isIPad] ? (FIN_DEVICE_WIDTH == 1024 && FIN_DEVICE_HEIGHT == 1366 ? 1 : 0) : 0;
    }
    return isIPadPro > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

//static NSInteger isSimulator = -1;
//+ (BOOL)isSimulator {
//    if (isSimulator < 0) {
//#if TARGET_OS_SIMULATOR
//        isSimulator = 1;
//#else
//        isSimulator = 0;
//#endif
//    }
//    return isSimulator > 0;
//}

static NSInteger is58InchScreen = -1;
+ (BOOL)is58InchScreen {
    if (is58InchScreen < 0) {
        is58InchScreen = (FIN_DEVICE_WIDTH == self.screenSizeFor58Inch.width && FIN_DEVICE_HEIGHT == self.screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger is55InchScreen = -1;
+ (BOOL)is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = (FIN_DEVICE_WIDTH == self.screenSizeFor55Inch.width && FIN_DEVICE_HEIGHT == self.screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
+ (BOOL)is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = (FIN_DEVICE_WIDTH == self.screenSizeFor47Inch.width && FIN_DEVICE_HEIGHT == self.screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
+ (BOOL)is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = (FIN_DEVICE_WIDTH == self.screenSizeFor40Inch.width && FIN_DEVICE_HEIGHT == self.screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
+ (BOOL)is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = (FIN_DEVICE_WIDTH == self.screenSizeFor35Inch.width && FIN_DEVICE_HEIGHT == self.screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

+ (CGSize)screenSizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

static NSInteger isHighPerformanceDevice = -1;
+ (BOOL)isHighPerformanceDevice {
    if (isHighPerformanceDevice < 0) {
        isHighPerformanceDevice = PreferredVarForUniversalDevices(1, 1, 1, 0, 0);
    }
    return isHighPerformanceDevice > 0;
}

/// Core
+ (UIImage *)fin_imageWithTintColor:(UIColor *)tintColor image:(UIImage *)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIViewController *)fin_topViewController:(UIViewController *)rootViewController
{
    if (!rootViewController) {
        return nil;
    }
    
    UIViewController *presentedViewController = rootViewController.presentedViewController;
    
    // 1.如果目标控制器的presentedVC存在，则继续往下查找
    if (presentedViewController) {
        return [self fin_topViewController:presentedViewController];
    }
    
    // 2.如果目标控制器的presentedVC不存在
    // 2.1 如果目标控制器是导航控制器
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self fin_topViewController:lastViewController];
    }
    
    // 2.2 如果目标控制器是tabbar控制器
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)rootViewController;
        UIViewController *selectedVC = [tabbarVC selectedViewController];
        return [self fin_topViewController:selectedVC];
    }
    
    return rootViewController;
}

@end






