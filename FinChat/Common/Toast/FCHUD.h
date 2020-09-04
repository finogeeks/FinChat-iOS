//
//  FINHUD.h
//  FinUICommon
//
//  Created by guoyong xu on 2018/7/16.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCHUD : NSObject

#pragma mark - loading
//展示loading界面
+ (void)showLoadingWithMessage:(NSString *)message;


#pragma mark - dismissLoading

/**
 隐藏
 */
+ (void)dismiss;

/**
 延迟隐藏
 
 @param delay 延时时间
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay;


#pragma mark - normalTipsMessage

/**
 展示提示消息 (该消息没有图片)

 @param message 提示消息
 */
+ (void)showTipsWithMessage:(NSString *)message;

/**
 展示提示消息 (该消息没有图片)
 
 @param message 提示消息
 @param time 消息显示时长
 */
+ (void)showTipsWithMessage:(NSString *)message time:(CGFloat)time;;

/**
 展示提示消息 (该消息没有图片)
 
 @param message 提示消息
 @param time 消息显示时长
 @param action 界面是否能够操作
 */
+ (void)showTipsWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action;


#pragma mark - warning
/**
 显示警告弹窗 （默认显示2秒） 整个window界面不可操作
 
 @param message 警告的消息
 */
+ (void)showWarningWithMessage:(NSString *)message;

/**
 显示警告弹窗 整个window界面不可操作
 
 @param message 警告的消息
 @param time 显示警告的时长
 */
+ (void)showWarningWithMessage:(NSString *)message time:(CGFloat)time;

/**
 显示警告弹窗
 
 @param message 警告的消息
 @param time 显示警告的时长
 @param action 界面是否能够操作
 */
+ (void)showWarningWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action;


#pragma mark - Error
/**
 显示错误弹窗 （默认显示2秒） 整个window界面不可操作
 
 @param message 错误的消息
 */
+ (void)showErrorWithMessage:(NSString *)message;

/**
 显示错误弹窗 整个window界面不可操作
 
 @param message 错误的消息
 @param time 显示错误的时长
 */
+ (void)showErrorWithMessage:(NSString *)message time:(CGFloat)time;

/**
 显示错误弹窗
 
 @param message 错误的消息
 @param time 显示错误的时长
 @param action 界面是否能够操作
 */
+ (void)showErrorWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action;


#pragma mark - success


/**
 显示成功弹窗 （默认显示2秒） 整个window界面不可操作
 
 @param message 错误的消息
 */
+ (void)showSuccessWithMessage:(NSString *)message;

/**
 显示成功弹窗 整个window界面不可操作
 
 @param message 错误的消息
 @param time 显示错误的时长
 */
+ (void)showSuccessWithMessage:(NSString *)message time:(CGFloat)time;

/**
 显示成功弹窗
 
 @param message 错误的消息
 @param time 显示错误的时长
 @param action 界面是否能够操作
 */
+ (void)showSuccessWithMessage:(NSString *)message time:(CGFloat)time action:(BOOL)action;


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
+ (UIAlertController *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonClickBlock:(void(^)(NSString *sender))leftButtonClickBlock rightButtonClickBlock:(void(^)(NSString *sender))rightButtonClickBlock;


/**
 显示alerView的方法 该方法只支持单个按钮
 
 @param title  标题
 @param message 描述文字
 @param buttonTitle 按钮的标题
 @param buttonClickBlock 按钮的点击事件
 */
+ (UIAlertController *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonClickBlock:(void(^)(NSString *sender))buttonClickBlock;

@end
