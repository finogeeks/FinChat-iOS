//
//  FCRegisterViewController.h
//  FinoChat
//
//  Created by zhao on 2017/12/19.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FCRegisterViewControllerType) {
    FCRegisterViewControllerTypeRegister = 0,
    FCRegisterViewControllerTypeForgetPwd,
};

@interface FCRegisterViewController : UIViewController

@property (nonatomic, assign)FCRegisterViewControllerType type;

@end
