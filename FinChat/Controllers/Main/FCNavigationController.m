//
//  FINNavigationControllerViewController.m
//  FinoChat
//
//  Created by 杨涛 on 2017/9/20.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import "FCNavigationController.h"
#import "FCLoginViewController.h"
#import "UIImage+Fino.h"
#import "UIColor+Fino.h"

#import <FinChatSDK/FINThemeManager.h>
#import <FinChatSDK/FinoChat.h>

@interface FCNavigationController ()

@end

@implementation FCNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)dealloc
{
    
}

- (void)setupUI
{
    [self.navigationBar setTranslucent:NO];
    
    __weak typeof(self)weakself = self;
    [FINThemeManager fin_addThemeDidChangeTarget:self didChangeBlock:^(FINThemeModel *themeModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.navigationBar.barTintColor = FINNavBackgroundColor;
            weakself.navigationBar.tintColor = FINNavBarItemNormalColor;
            // 设置navBar选中时字体颜色添加到主题色池中
            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
            textAttrs[NSForegroundColorAttributeName] = FINNavTitleColor;
            textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
            [weakself.navigationBar setTitleTextAttributes:textAttrs];
            
            // 登录页面不改变状态栏颜色
            UIViewController *rootVC = [weakself.viewControllers firstObject];
            if (![rootVC isKindOfClass:[FCLoginViewController class]]) {
                [UIApplication sharedApplication].statusBarStyle = FINStatusBarStyle;
            }
        });
        
       
    }];

}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}


//FIXME:这样做防止主界面卡顿时，导致一个ViewController被push多次
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //统一设置返回按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = backItem;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:18.0]};
        [viewController.navigationItem.backBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        /// 防止room被多次push
        // XGY :tips = 不要这样做 这样点击消息打开房间的时候有问题 房间推房间推不动
//        if ([[self.childViewControllers lastObject] isKindOfClass:viewController.class]
//            && [viewController isKindOfClass:NSClassFromString(@"FINChatViewController")] ) {
//            return;
//        }
    }

    [super pushViewController:viewController animated:animated];
}

@end
