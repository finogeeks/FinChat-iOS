//
//  FINMainController.m
//  FinChat
//
//  Created by Haley on 2018/7/31.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "FINMainController.h"
#import "FCNavigationController.h"
#import "AppDelegate.h"

#import "UIColor+Fino.h"
#import "FCUIHelper.h"
#import "FCHUD.h"

#import <FinChatSDK/FinoChat.h>

// 授权
#import "Constants.h"
#import "FCService.h"

@interface FINMainController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) dispatch_queue_t updateBadgeQueue;

@end

@implementation FINMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _updateBadgeQueue = dispatch_queue_create("tabbar_updateBadge_queue", DISPATCH_QUEUE_SERIAL);
    
    [self setupTabbar];
    
    [self setupViewControllers];
    
    // 先添加初始化SDK成功的通知，
    // 然后在在通知触发的处理函数中再添加接收消息和邀请房间变更的通知
    [self addNotifications];
    
    [self checkUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = FINStatusBarStyle;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([self checkIsDoubleClick:viewController]) {
        [[FinoChatClient sharedInstance].finoChatRoomManager scrollToUnreadRoom];
    }
    return YES;
}

#pragma mark - private method
- (BOOL)checkIsDoubleClick:(UIViewController *)viewController
{
    static UIViewController *lastViewController = nil;
    static NSTimeInterval lastClickTime = 0;
    if (lastViewController != viewController) {
        lastViewController = viewController;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        return NO;
    }
    
    //双击间隔 0.5
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.5 ) {
        lastClickTime = clickTime;
        return NO;
    }
    lastClickTime = clickTime;
    return YES;
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadges) name:kFinoChatInitSDKDataReadyNotification object:nil];
}

- (void)setupTabbar
{
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    if (@available(iOS 10.0, *)) {
        UITabBarItem *tabbarItem = [UITabBarItem appearance];
        tabbarItem.badgeColor =  [UIColor fin_colorWithHexString:@"#EA4335"];
    }
}

- (void)updateBadges
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnReadMsgCount) name:kFinoChatReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInvitedRoomsCount) name:kFinoChatInvitedRoomsChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFanMessageCount) name:kFinoChatFanMessageCountDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFanMessageCount) name:kFinoChatTaskMessageCountDidChangeNotification object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger count1 = [[[FinoChatClient sharedInstance] finoChatRoomManager] missedNotificationsCount];
        NSInteger invitedRoomsCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] invitedRoomsCount];
         NSInteger fanMessageUnReadCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] fanMessageUnReadCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTabbarBadgeValue:count1 tabbarIndex:0];
            [self setTabbarBadgeValue:invitedRoomsCount tabbarIndex:1];
            [self setTabbarBadgeValue:fanMessageUnReadCount tabbarIndex:2];
        });
    });
}

- (void)updateUnReadMsgCount
{
    dispatch_async(_updateBadgeQueue, ^{
        NSInteger count1 = [[[FinoChatClient sharedInstance] finoChatRoomManager] missedNotificationsCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTabbarBadgeValue:count1 tabbarIndex:0];
        });
    });
}

- (void)updateInvitedRoomsCount
{
    dispatch_async(_updateBadgeQueue, ^{
        NSInteger invitedRoomsCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] invitedRoomsCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTabbarBadgeValue:invitedRoomsCount tabbarIndex:1];
        });
    });
}

- (void)updateFanMessageCount
{
    dispatch_async(_updateBadgeQueue, ^{
        NSInteger fanMessageUnReadCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] fanMessageUnReadCount];
        NSInteger tasMessagekUnReadCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] taskMessageUnReadCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTabbarBadgeValue:(fanMessageUnReadCount + tasMessagekUnReadCount) tabbarIndex:2];
        });
    });
}

- (void)checkUpdate
{
    NSNumber *lastCheckTimeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastCheckTimeKey"];
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    if (lastCheckTimeNumber) {
        // 如果间隔小于24小时，就不再提示
        if ((timestamp - lastCheckTimeNumber.doubleValue) < 24 * 60 * 60) {
            return;
        }
    }
    
    [[FCService sharedInstance] checkUpdate:^(NSDictionary *result, NSError *error) {
        if (error) {
            return ;
        }
        NSString *version = [result objectForKey:@"version"];
        NSString *remarks = [result objectForKey:@"remarks"];
        NSString *url = [result objectForKey:@"url"];
        NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *title = [NSString stringWithFormat:@"\"%@\"发现了新的版本", appName];
        
        NSComparisonResult compareResult = [[FCService sharedInstance] compareFirst:currentVersion toSecond:version];
        if (compareResult == NSOrderedAscending) {
            // 显示弹窗
            NSString *msg = remarks;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@(timestamp) forKey:@"kLastCheckTimeKey"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            [alertController addAction:sureAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@(timestamp) forKey:@"kLastCheckTimeKey"];
            }];
            [alertController addAction:cancelAction];
            UIViewController *topVC = [FCUIHelper fin_topViewController:self];
            [topVC presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)setupViewControllers
{
    // 消息
    UIViewController *messageVC = [[FinoChatClient sharedInstance].finoChatUIManager conversationViewController];
    [self addOneChlildVc:messageVC title:@"消息" imageName:@"btn-xiaoxi-n" selectedImageName:@"btn-xiaoxi-h"];
    // 通讯录
    UIViewController *contactVC = [[FinoChatClient sharedInstance].finoChatUIManager addressBookControllerWithContactsDelegate:nil contactsDataSource:nil];
    [self addOneChlildVc:contactVC title:@"通讯录" imageName:@"btn-tongxunlu-n" selectedImageName:@"btn-tongxunlu-h"];
    // 工作
    UIViewController *workVC = [[FinoChatClient sharedInstance].finoChatUIManager workViewController];
    [self addOneChlildVc:workVC title:@"工作" imageName:@"btn-gongzuo-n" selectedImageName:@"btn-gongzuo-h"];
    // 我
    NSArray *list = @[
                        @[@{@"cellMark": @"kFINMineUerInfoCellMark"}],
                        @[@{@"cellMark": @"kFINMineSetCustZoneCellMark"}],
                        @[@{@"cellMark": @"kFINMineSetCellMark"}]
                    ];
    UIViewController *mineVC = [[FinoChatClient sharedInstance].finoChatUIManager mineViewControllerWithList:list callback:nil];
    [self addOneChlildVc:mineVC title:@"我" imageName:@"btn-wo-n" selectedImageName:@"btn-wo-h"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor fin_colorWithHexString:@"c4c4c4"];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem  setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    childVc.tabBarItem.title = title;
    // 设置正常状态图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
  
    __weak typeof(self)weakSelf = self;
    __weak typeof(childVc)weakVc = childVc;
    [FINThemeManager fin_addThemeDidChangeTarget:self didChangeBlock:^(FINThemeModel *themeModel) {
        NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
        selectedTextAttrs[NSForegroundColorAttributeName] = FINThemeNormalColor;
        selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [weakVc.tabBarItem  setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
        weakSelf.tabBar.tintColor = FINThemeNormalColor;
        // 设置选中的图标
        UIImage *selectedImage = [FCUIHelper fin_imageWithTintColor:FINThemeNormalColor image:[UIImage imageNamed:selectedImageName]];
        weakVc.tabBarItem.selectedImage = selectedImage;
    }];
    //设置标题
    childVc.title = title;
    
    // 添加为tabbar控制器的子控制器
    FCNavigationController *nav = [[FCNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - public method
- (void)setTabbarBadgeValue:(NSInteger)badge tabbarIndex:(NSInteger)tabbarIndex
{
    if (tabbarIndex >= self.childViewControllers.count) {
        return;
    }

    UIViewController *viewController = self.childViewControllers[tabbarIndex];
    UITabBarItem *item = viewController.tabBarItem;
    if (badge >= 100) {
        item.badgeValue = @"...";
    } else {
        item.badgeValue = badge > 0 ? [NSString stringWithFormat:@"%ld", (long)badge] : nil;
    }
}

@end
