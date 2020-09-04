//
//  FINLoginViewController.h
//  FinoChat
//
//  Created by 杨涛 on 2017/9/20.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@protocol ILoginStatusProtocol

- (void)loginSuccess;
- (void)loginFailed;

@end

@interface FCLoginViewController : FCViewController

@property (strong, nonatomic) id delegate;

@end
