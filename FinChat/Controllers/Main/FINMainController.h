//
//  FINMainController.h
//  FinChat
//
//  Created by Haley on 2018/7/31.
//  Copyright © 2018年 finogeeks. All rights reserved.
//
//  这个类是准备重构完毕 (准备重构调旧的FCMainViewController)

#import <UIKit/UIKit.h>

@interface FINMainController : UITabBarController

- (void)setTabbarBadgeValue:(NSInteger)badge tabbarIndex:(NSInteger)tabbarIndex;

@end
