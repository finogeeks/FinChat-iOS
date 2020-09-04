//
//  FINLoginViewController.m
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import "FCLoginViewController.h"
#import "FCPhoneVerifyViewController.h"
#import "FCServerSettingSelectVC.h"
#import "FCHUD.h"
#import "UIColor+Fino.h"
#import "FINAuthViewController.h"
#import "Constants.h"

#import <FinChatSDK/FinoChat.h>
#import <FinChatSDK/FinoChatConst.h>

@interface FCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *visibilityBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@property (assign, nonatomic) BOOL needAnimation;

@end

@implementation FCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fin_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:self.needAnimation];
 
    // 登录页面状态栏固定UIStatusBarStyleDefault
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self fin_setRegisterShown];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fin_addTextFiledObserver];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)fin_setupUI
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kFINLoginAccount];
    self.userNameTF.text = userName;
    self.userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.loginBtn.enabled = NO;
    self.loginBtn.backgroundColor = FINThemeDisableColor;
    
    [self.forgetPwdBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    [self.settingBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
}

- (void)fin_setRegisterShown
{
    // 根据服务器地址显示注册
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* apiurl = [userDefaults stringForKey:@"finochat_apiurl"];
    //要求OA环境与公有云环境统一，开放注册功能
//    if ([apiurl isEqualToString:@"https://api.finogeeks.com"] || [apiurl isEqualToString:@"http://api.finogeeks.com"]) {
//        self.forgetPwdBtn.hidden = NO;
//        self.registerBtn.hidden = NO;
//    } else {
//        self.forgetPwdBtn.hidden = YES;
//        self.registerBtn.hidden = YES;
//    }
}

- (void)fin_addTextFiledObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // `下一步`按钮状态控制
        if (self.userNameTF.text.length >0 && self.passwordTF.text.length > 0) {
            
            self.loginBtn.enabled = YES;
            self.loginBtn.backgroundColor = FINThemeNormalColor;
        } else {
            
            self.loginBtn.enabled = NO;
            self.loginBtn.backgroundColor = FINThemeDisableColor;
        }
    }];
}

#pragma mark - Actions

- (IBAction)login:(id)sender {
    
    static double oldtime = 0;
    double nowtime = [[NSDate date] timeIntervalSince1970];
    //限制3秒内只能点击一次有效，防止多次点击后跳出多个VC的问题
    if ((nowtime - oldtime) < 2) {
        return;
    }

    [self.view endEditing:YES];
    
    // 去掉首尾的空格
    NSString *userName = [self.userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [FCHUD showLoadingWithMessage:@"登录中"];
    __weak typeof(self) weakSelf = self;
    [[FinoChatClient sharedInstance].finoAccountManager login:userName password:password success:^(NSDictionary* ret) {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kFINLoginAccount];
        [FCHUD dismiss];
        if (weakSelf.isFromAuth) {
            NSString *userId = [FINServiceFactory sharedInstance].currentUserId;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@:%@", weakSelf.reDirectUrl, userId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinoChatLoginSuccessNotification object:nil];
    } failure:^(NSError *error) {
        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];
}

- (IBAction)setPwdVisiblity:(id)sender {
    self.visibilityBtn.selected = !self.visibilityBtn.isSelected;
    if (self.visibilityBtn.isSelected) {
        self.passwordTF.secureTextEntry = NO;
    } else {
        self.passwordTF.secureTextEntry = YES;
    }
}

- (IBAction)forgetPwd:(id)sender {
    FCPhoneVerifyViewController *phoneVerifyVC = [[FCPhoneVerifyViewController alloc] initWithVerifyType:FCPhoneVerifyType_ResetPassword];
    [self.navigationController pushViewController:phoneVerifyVC animated:YES];
}

- (IBAction)registerAccount:(id)sender {
    FCPhoneVerifyViewController *phoneVerifyVC = [[FCPhoneVerifyViewController alloc] initWithVerifyType:FCPhoneVerifyType_Register];
    [self.navigationController pushViewController:phoneVerifyVC animated:YES];
}

- (IBAction)setting:(id)sender {
    FCServerSettingSelectVC *vc = [FCServerSettingSelectVC new];
    self.needAnimation = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
