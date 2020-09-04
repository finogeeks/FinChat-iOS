//
//  UIColor+Fino.h
//  FinChat
//
//  Created by 杨涛 on 2018/2/28.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorHEX(string) [UIColor fin_colorWithHexString:string]

@interface UIColor (Fino)
+ (UIColor *)fin_colorWithHexString:(NSString *)color;
+ (UIColor *)fin_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end

