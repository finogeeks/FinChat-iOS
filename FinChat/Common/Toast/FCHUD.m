//
//  FINHUD.m
//  FinUICommon
//
//  Created by guoyong xu on 2018/7/16.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "FCHUD.h"
#import <SVProgressHUD.h>

@implementation FCHUD

+ (void)initialize {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //style + color
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
         [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setCornerRadius:5.0f];
        [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        //size
        [SVProgressHUD setImageViewSize:CGSizeMake(40, 40)];
        
        //Resource
        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"public_toast_fail"]];
        [SVProgressHUD setSuccessImage: [UIImage imageNamed:@"public_toast_succeed"]];
        [SVProgressHUD setInfoImage:[UIImage imageNamed:@"public_toast_warming"]];
    });
    
}
/**
 展示loading界面
 
 @param message loading消息
 */
+ (void)showLoadingWithMessage:(NSString *)message
{
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    [SVProgressHUD showWithStatus:message];
    
}

/**
 隐藏
 */
+ (void)dismiss
{
    [FCHUD dismissWithDelay:0];
}

/**
 延迟隐藏
 
 @param delay 延时时间
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay
{
    [SVProgressHUD dismissWithDelay:delay];
    
    
}

#pragma mark - normalTipsMessage

/**
 展示提示消息 (该消息没有图片)
 
 @param message 提示消息
 */
+ (void)showTipsWithMessage:(NSString *)message
{
    if (!message) {
        return;
    }
    [FCHUD showTipsWithMessage:message time:2];
    
}

/**
 展示提示消息 (该消息没有图片)
 
 @param message 提示消息
 @param time 消息显示时长
 */
+ (void)showTipsWithMessage:(NSString *)message time:(CGFloat)time
{
    if (!message) {
        return;
    }
    [FCHUD showTipsWithMessage:message time:time action:NO];
}

/**
 展示提示消息 (该消息没有图片)
 
 @param message 提示消息
 @param time 消息显示时长
 @param action 界面是否能够操作
 */
+ (void)showTipsWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action
{
    if (!message) {
        return;
    }
    SVProgressHUDMaskType type = action? SVProgressHUDMaskTypeNone :SVProgressHUDMaskTypeClear;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD setMinimumSize:CGSizeZero];
    [SVProgressHUD setMaximumDismissTimeInterval:time];
    [SVProgressHUD showImage:nil status:message];
}




/**
 显示警告弹窗 （默认显示2秒） 整个window界面不可操作
 
 
 param message 警告的消息
 */
+ (void)showWarningWithMessage:(NSString *)message
{
    if (!message) {
        return;
    }
    [FCHUD showWarningWithMessage:message time:2 action:NO];
}

/**
 显示警告弹窗 整个window界面不可操作
 
 @param message 警告的消息
 @param time 显示警告的时长
 */
+ (void)showWarningWithMessage:(NSString *)message time:(CGFloat)time
{
    if (!message) {
        return;
    }
    [FCHUD showWarningWithMessage:message time:time action:NO];
}

/**
 显示警告弹窗
 
 @param message 警告的消息
 @param time 显示警告的时长
 @param action 界面是否能够操作
 */
+ (void)showWarningWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action
{
    if (!message) {
        return;
    }
    SVProgressHUDMaskType type = action? SVProgressHUDMaskTypeNone :SVProgressHUDMaskTypeClear;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    [SVProgressHUD setMaximumDismissTimeInterval:time];
    [SVProgressHUD showInfoWithStatus:message];
    [SVProgressHUD setHapticsEnabled:action];
    
}
/**
 显示错误弹窗 （默认显示2秒） 整个window界面不可操作
 
 @param message 错误的消息
 */
+ (void)showErrorWithMessage:(NSString *)message
{
    if (!message) {
        return;
    }
    [FCHUD showErrorWithMessage:message time:2 action:NO];
    
}

/**
 显示错误弹窗 整个window界面不可操作
 
 @param message 错误的消息
 @param time 显示错误的时长
 */
+ (void)showErrorWithMessage:(NSString *)message time:(CGFloat)time
{
    if (!message) {
        return;
    }
    [FCHUD showErrorWithMessage:message time:time action:NO];
}

/**
 显示错误弹窗
 
 @param message 错误的消息
 @param time 显示错误的时长
 @param action 界面是否能够操作
 */
+ (void)showErrorWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action
{
    if (!message) {
        return;
    }
    SVProgressHUDMaskType type = action? SVProgressHUDMaskTypeNone :SVProgressHUDMaskTypeClear;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    [SVProgressHUD setMaximumDismissTimeInterval:time];
    [SVProgressHUD showErrorWithStatus:message];
    
    
}


/**
 显示成功弹窗 （默认显示2秒） 整个window界面不可操作
 
 @param message 错误的消息
 */
+ (void)showSuccessWithMessage:(NSString *)message
{
    if (!message) {
        return;
    }
    [FCHUD showSuccessWithMessage:message time:2 action:NO];
}

/**
 显示成功弹窗 整个window界面不可操作
 
 @param message 错误的消息
 @param time 显示错误的时长
 */
+ (void)showSuccessWithMessage:(NSString *)message time:(CGFloat)time
{
    if (!message) {
        return;
    }
    [FCHUD showSuccessWithMessage:message time:time action:NO];
}

/**
 显示成功弹窗
 
 @param message 错误的消息
 @param time 显示错误的时长
 @param action 界面是否能够操作
 */
+ (void)showSuccessWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action
{
    if (!message) {
        return;
    }
    SVProgressHUDMaskType type = action? SVProgressHUDMaskTypeNone :SVProgressHUDMaskTypeClear;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    [SVProgressHUD setMaximumDismissTimeInterval:time];
    [SVProgressHUD showSuccessWithStatus:message];
}




#pragma mark - AlertView

/**
 显示alerView的方法 该方法只支持左右两个按钮
 
 @param title 标题
 @param message 描述文字
 @param leftButtonTitle 左边按钮的标题
 @param rightButtonTitle 右边按钮的标题
 @param leftButtonClickBlock 左边按钮的点击的回调
 @param rightButtonClickBlock 右边按钮的点击的回调
 */
+ (UIAlertController *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonClickBlock:(void(^)(NSString *sender))leftButtonClickBlock rightButtonClickBlock:(void(^)(NSString *sender))rightButtonClickBlock
{
    
    [FCHUD dismiss];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:leftButtonTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if (leftButtonClickBlock) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      leftButtonClickBlock(leftButtonTitle);
                                                                  });
                                                              }
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:rightButtonTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             if (rightButtonClickBlock) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     rightButtonClickBlock(rightButtonTitle);
                                                                 });
                                                             }
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    UIViewController *rootController = [FCHUD currentViewController];
    [rootController presentViewController:alert animated:YES completion:nil];
    return alert;
    
}

/**
 显示alerView的方法 该方法只支持单个按钮
 
 @param title  标题
 @param message 描述文字
 @param buttonTitle 按钮的标题
 @param buttonClickBlock 按钮的点击事件
 */
+ (UIAlertController *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonClickBlock:(void(^)(NSString *sender))buttonClickBlock
{
    [FCHUD dismiss];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if (buttonClickBlock) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      buttonClickBlock(buttonTitle);
                                                                  });
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    UIViewController *rootController = [FCHUD currentViewController];
    [rootController presentViewController:alert animated:YES completion:nil];
     return alert;
}











//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
