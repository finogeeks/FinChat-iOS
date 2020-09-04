//
//  FINPushNotifacationManager.m
//  FinChat
//
//  Created by guoyong xu on 2018/8/22.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "FINPushNotifacationManager.h"
#import <FinChatSDK/FinoChat.h>

@implementation FINPushNotifacationManager

+ (void)pushToChatRoomOptions:(NSDictionary *)launchOptions didReceiveRemoteNotification:(NSDictionary*)userInfo
{
}

+ (void)testpushToChatRoomOptions:(NSDictionary *)launchOptions didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
#ifndef FIN_INTERNAL
    if (state == UIApplicationStateBackground) {
        //原来的逻辑 不知为何这样处理
        [[FinoChatClient sharedInstance].finoAccountManager backgroundSync:20000];
    }
    return;
#endif
    
    //未登录 不处理
    if (![[FinoChatClient sharedInstance].finoAccountManager isLogin]) {
        return;
    }
    
    
    
    if (launchOptions) {
        userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    //UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateBackground) {
        //原来的逻辑 不知为何这样处理
        [[FinoChatClient sharedInstance].finoAccountManager backgroundSync:20000];
    }
    //获取到 roomId
    NSString* roomId = [userInfo objectForKey:@"room_id"];
    //判断是不是邀请消息
    NSDictionary* aps = [userInfo objectForKey:@"aps"];
    NSString* loc_key = [[aps objectForKey:@"alert"] objectForKey:@"loc-key"];
    BOOL isInvite = [loc_key isEqualToString:@"USER_INVITE_TO_CHAT"];
    
    
    if (!roomId ||roomId.length == 0 || isInvite) {
        //消息不处理
        return;
    }
    
    
    if (state ==  UIApplicationStateInactive || launchOptions)
    {
        UIViewController *chatController = [[FinoChatClient sharedInstance].finoChatUIManager chatViewControllerWithRoomId:roomId];
        UIViewController *pushController = [self getCurrentVC];
        UINavigationController *navPush = nil;
        if ([pushController isKindOfClass:[UINavigationController class]]) {
            navPush = (UINavigationController *)pushController;
            
        } else if (pushController.navigationController) {
            navPush = pushController.navigationController;
        } else {
            //啥都没有 没遇到这种情况 不处理
        }
        
        //就在当前的房间 不处理
        if ([navPush isKindOfClass:[UINavigationController class]] ) {
            UIViewController *current = [navPush.viewControllers lastObject];
            if ([current isKindOfClass:[chatController class]]) {
                if ([[current valueForKey:@"roomId"] isEqualToString:roomId]) {
                    return;
                }
            }
        }
        
        [navPush pushViewController:chatController animated:YES];
        //如果导航栏被隐藏了 打开来(小程序把他隐藏了 但是没有打开)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (navPush.navigationBarHidden) {
                [navPush setNavigationBarHidden:NO animated:YES];
            }
        });
    }
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        currentVC = rootVC;
    }
    
    return currentVC;
}
@end
