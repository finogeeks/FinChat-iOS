//
//  AppDelegate.m
//  FinoChat
//
//  Created by 杨涛 on 2017/9/19.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import <FinChatSDK/FinoChat.h>
#import <RACDelegateProxy.h>
#import <Masonry/Masonry.h>
#import <Bugly/Bugly.h>

#import "AppDelegate.h"
#import "FCNavigationController.h"
#import "FCLoginViewController.h"
#import "FINMainController.h"
#import "UIImage+Fino.h"
#import "UIColor+Fino.h"
#import "FCUIHelper.h"
#import "FCHUD.h"

#import "FINAuthViewController.h"

#import "FCService.h"
#import "FINPushNotifacationManager.h"
#import <FinChatSDK/FINThemeManager.h>

@interface AppDelegate ()
{
    // background sync management
    void (^_completionHandler)(UIBackgroundFetchResult);
    
}
@property (nonatomic, nullable, copy) void (^registrationForRemoteNotificationsCompletion)(NSError *);

/**
 是否允许用户推送
 */
@property (nonatomic, assign) BOOL isEnableNotifacation;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [self registerUserNotificationSettings];
    
    // 1.设置主题色
    [FINThemeManager removeCurrentThemeType];
    [FINThemeManager setThemeType:FINThemeType_Red];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
//    [FINThemeManager setThemeTypeWithThemeFilePath:path];
    
    // 2.初始化SDK
    NSError *error = nil;
    BOOL result = [[FCService sharedInstance] initSDK:&error];
    if (!result) {
        NSLog(@"初始化SDK失败:%@", error.localizedDescription);
    }
    
    [self p_setupUI:userInfo];
    
    [self p_addLogoutNotification];
    
    [self addLoginObserver];
    
    [self addUnknownTokenNotification];
    
    [self addDeviceVerifyRequestObserver];
    
    [self addPwdChangeKickNotification];
    
    // 微信分享注册
    [[FinoChatClient sharedInstance].finoThirdPShareManager registerWXShare:@{
                                                                              @"wxId": @"wxba921605434e0281",
                                                                              @"appletId": @"gh_8a6a81029506"
                                                                              }];
    [[FinoChatClient sharedInstance].finoThirdPShareManager registerWeiBoShare:@{@"wbAppkey":@"3957778627",
                                                                                 @"redirectURI":@"https://api.weibo.com/oauth2/default.html"
                                                                                 }];
    [[FinoChatClient sharedInstance].finoThirdPShareManager registerQQShare:@{@"appId":@"101698280"}];
    
    NSLog(@"version:%@",[FinoChatClient sharedInstance].version);
    
    NSLog(@"build:%@",[FinoChatClient sharedInstance].build);
    
    BuglyConfig * blyconfig       = [[BuglyConfig alloc] init];
    blyconfig.reportLogLevel      = BuglyLogLevelWarn;
    blyconfig.blockMonitorEnable  = YES;
    blyconfig.blockMonitorTimeout = 1;
    [Bugly startWithAppId:@"71e7c0e5ff" config:blyconfig];
    
    return YES;
}

#pragma mark - private

- (void)p_setupUI:(NSDictionary*)userInfo
{
    if ([[FinoChatClient sharedInstance].finoAccountManager isLogin]){
        self.window.rootViewController = [[FINMainController alloc] init];
        //如果userInfo 有内容说明是点击通知打开的应用,如果没有内容则是点击icon打开的应用
    } else {
        FCLoginViewController *loginvc = [[FCLoginViewController alloc] init];
        FCNavigationController *navVC = [[FCNavigationController alloc] initWithRootViewController:loginvc];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        [self.window setRootViewController:navVC];
    }
    [self.window makeKeyAndVisible];
}

- (void)changeToLoginVC
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    FCLoginViewController *loginvc = [[FCLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginvc];
    [nav.navigationBar setTranslucent:NO];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)refreshApplicationIconBadgeNumber
{
    // 后台推送已改为消息总数
    UIViewController *rootVC = self.window.rootViewController;
    if (![rootVC isKindOfClass:[FINMainController class]]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger count = [[[FinoChatClient sharedInstance] finoChatRoomManager] missedNotificationsCount];
        NSInteger invitedRoomsCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] invitedRoomsCount];
        NSInteger fanMessageUnReadCount = [[[FinoChatClient sharedInstance] finoChatRoomManager] fanMessageUnReadCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = count + invitedRoomsCount + fanMessageUnReadCount;
            [(FINMainController *)rootVC setTabbarBadgeValue:count tabbarIndex:0];
            [(FINMainController *)rootVC setTabbarBadgeValue:invitedRoomsCount tabbarIndex:1];
            [(FINMainController *)rootVC setTabbarBadgeValue:fanMessageUnReadCount tabbarIndex:2];
        });
    });
}

- (BOOL)isUserNotificationEnable
{
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable =  (UIUserNotificationTypeNone != setting.types);
    }
    return isEnable;
}

- (void)cancelBackgroundSync
{
    if (_completionHandler)
    {
        _completionHandler(UIBackgroundFetchResultNoData);
        _completionHandler = nil;
    }
}

- (void)registerUserNotificationSettings
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)registerForRemoteNotificationsWithCompletion:(nullable void (^)(NSError *))completion
{
    self.registrationForRemoteNotificationsCompletion = completion;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - add Notifications
- (void)addLoginObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:kFinoChatLoginSuccessNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        self.window.rootViewController = [[FINMainController alloc] init];
    }];
}

- (void)addUnknownTokenNotification
{
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kFinoChatUnknownTokenNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        UIViewController *rootVC = weakSelf.window.rootViewController;
        if ([rootVC isKindOfClass:[FINMainController class]]) {
            NSString *msg = @"很抱歉，您的登录信息已过期，建议您重新登录";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再次尝试" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[FinoChatClient sharedInstance].finoAccountManager logout];
                [weakSelf changeToLoginVC];
            }];
            [alertController addAction:sureAction];
            
            UIViewController *topVC = [FCUIHelper fin_topViewController:rootVC];
            [topVC presentViewController:alertController animated:YES completion:nil];
            return ;
        }
    }];
}

- (void)p_addLogoutNotification
{
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.finogeeks.finochat.event.logout" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            FCLoginViewController *loginvc = [[FCLoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginvc];
            [nav.navigationBar setTranslucent:NO];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            strongSelf.window.rootViewController = nav;
            [strongSelf.window makeKeyAndVisible];
        });
    }];
}

- (void)addDeviceVerifyRequestObserver
{
    NSString *udid = [[FinoChatClient sharedInstance].finoAccountManager finUDID];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"com.finogeeks.finochat.device.verifyRequested" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *deviceId = note.object;
        //后端在deviceId后加了一段字符串，deviceId:xxx，对字符串拆分兼容
        NSArray *array = [deviceId componentsSeparatedByString:@":"];
        for (NSString *str in array) {
            if ([str isEqualToString:udid]) {
                deviceId = str;
                return ;
            }
        }

        NSString *msg = [NSString stringWithFormat:@"请求验证的设备ID：%@", deviceId];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证设备" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if (deviceId) {
              [[FinoChatClient sharedInstance] verifyDevice:deviceId success:^{
                  
              } failure:^(NSError *error) {
                  
              }];
          }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          
        }]];
        UIViewController *topVC = [FCUIHelper fin_topViewController:self.window.rootViewController];
        [topVC presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)addPwdChangeKickNotification
{
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kFinoChatPwdChangeKickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        UIViewController *rootVC = weakSelf.window.rootViewController;
        if (![rootVC isKindOfClass:[UITabBarController class]]) {
            return;
        }
        
        [[FinoChatClient sharedInstance].finoAccountManager logout];
        weakSelf.window.rootViewController = [[FCLoginViewController alloc] init];
        
        [FCHUD showWarningWithMessage:@"您已修复密码，请重新登录"];
    }];
}

#pragma mark - application life circle
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    BOOL enable = [self isUserNotificationEnable];
    if (enable && !self.isEnableNotifacation) {
        //原来没有打开 现在打开了
        [self registerUserNotificationSettings];
    }
    [self cancelBackgroundSync];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    [self refreshApplicationIconBadgeNumber];
    self.isEnableNotifacation = [self isUserNotificationEnable];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    [self refreshApplicationIconBadgeNumber];
    //    [self.audioPlayer play];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}



#pragma mark - OpenURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url
{
    [[FinoChatClient sharedInstance] handleOpenURL:url];
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    [[FinoChatClient sharedInstance] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.absoluteString hasPrefix:@"finchat://auth:"]) {
        NSString *redirectURI = [url.absoluteString stringByReplacingOccurrencesOfString:@"finchat://auth:" withString:@""];
        BOOL isLogin = [FinoChatClient sharedInstance].finoAccountManager.isLogin;
        if (isLogin) {
            
            FINAuthViewController *authViewController = [[FINAuthViewController alloc] initWithNibName:nil bundle:nil];
            authViewController.reDirectUrl = redirectURI;
            
            FINMainController *mainVC = [[FINMainController alloc] init];
            self.window.rootViewController = mainVC;
            [self.window makeKeyAndVisible];
            [mainVC presentViewController:authViewController animated:NO completion:nil];
        } else {
            
            FCLoginViewController *loginvc = [[FCLoginViewController alloc] init];
            loginvc.isFromAuth = YES;
            loginvc.reDirectUrl = redirectURI;
            FCNavigationController *navVC = [[FCNavigationController alloc] initWithRootViewController:loginvc];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            [self.window setRootViewController:navVC];
        }
        return NO;
    }
    [[FinoChatClient sharedInstance] handleOpenURL:url options:options];
    return NO;
}


#pragma mark - APNS
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register for remote notifications only if user provide access to notification feature
    if (notificationSettings.types != UIUserNotificationTypeNone)
    {
        [self registerForRemoteNotificationsWithCompletion:nil];
    }
    else
    {
        // Clear existing token
        [[FinoChatClient sharedInstance].finoAccountManager setApnsDeviceToken:nil];
    }
}

- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUInteger len = ((deviceToken.length > 8) ? 8 : deviceToken.length / 2);
    NSLog(@"[AppDelegate] Got APNS token! (%@ ...)", [deviceToken subdataWithRange:NSMakeRange(0, len)]);
    NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *voipPushTokenID = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                  stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"voipPushTokenID=%@",voipPushTokenID);
    [[FinoChatClient sharedInstance].finoAccountManager setApnsDeviceToken:deviceToken];
    
    
    if (self.registrationForRemoteNotificationsCompletion)
    {
        self.registrationForRemoteNotificationsCompletion(nil);
        self.registrationForRemoteNotificationsCompletion = nil;
    }
}

- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"[AppDelegate] Failed to register for APNS: %@", error);
    
    if (self.registrationForRemoteNotificationsCompletion)
    {
        self.registrationForRemoteNotificationsCompletion(error);
        self.registrationForRemoteNotificationsCompletion = nil;
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[FinoChatClient sharedInstance] handleRemoteNotification:userInfo];
    //点击消息跳转到聊天房间
    [FINPushNotifacationManager pushToChatRoomOptions:nil didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // iOS 10 (at least up to GM beta release) does not call application:didReceiveRemoteNotification:fetchCompletionHandler:
    // when the user clicks on a notification but it calls this deprecated version
    // of didReceiveRemoteNotification.
    // Use this method as a workaround as adviced at http://stackoverflow.com/a/39419245
    NSLog(@"[AppDelegate] didReceiveRemoteNotification (deprecated version)");
    
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        
    }];
    
    [[FinoChatClient sharedInstance].finoChatUIManager chatViewControllerWithRoomId:nil];
}

#pragma mark - application orientation
- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return [[FinoChatClient sharedInstance].finoChatUIManager controllerOrientationMask];
}

@end

