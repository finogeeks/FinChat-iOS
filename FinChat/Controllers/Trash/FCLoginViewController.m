//
//  FINLoginViewController.m
//  FinoChat
//
//  Created by 杨涛 on 2017/9/20.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import "FCLoginViewController.h"
#import <FinChatSDK/FinoChat.h>
#import <RACEXTScope.h>
#import "UIImage+Implementation.h"
#import "UIColor+Fino.h"
#import "FCRegisterViewController.h"
#import "FCSettingViewController.h"
#import "FCSetUserNameViewController.h"
#import "FCServerSettingSelectVC.h"
#import <FinChatSDK/FINThemeManager.h>

@interface FCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (nonatomic,strong)UIBarButtonItem* rightButton;

@end

@implementation FCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInFailureText.hidden = YES;
    [self p_bindViewModel];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    self.loginBtn.enabled = YES;
    
//    [self.loginBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#4285f4"]] forState:UIControlStateNormal];
//    [self.loginBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#2e6fda"]] forState:UIControlStateHighlighted];
//    self.loginBtn.layer.borderColor = [UIColor fin_colorWithHexString:@"#2e6fda"].CGColor;
//    self.loginBtn.layer.borderWidth = 1.0f;
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    //
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"set"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSetting)];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
     if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    __weak typeof(self)weakself = self;
    [FINThemeManager fin_addThemeDidChangeTarget:self didChangeBlock:^(FINThemeModel *themeModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.navigationController.navigationBar.barTintColor = FINNavBackgroundColor;
            weakself.navigationController.navigationBar.tintColor = FINNavBarItemNormalColor;
            // 设置navBar选中时字体颜色添加到主题色池中
            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
            textAttrs[NSForegroundColorAttributeName] = FINNavTitleColor;
            textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
            [weakself.navigationController.navigationBar setTitleTextAttributes:textAttrs];
            [UIApplication sharedApplication].statusBarStyle = FINStatusBarStyle;
        });
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* apiurl = [userDefaults stringForKey:@"finochat_apiurl"];
    BOOL isShow = NO;
//    if ([[FinoChatClient sharedInstance].options.config.settings[@"isRegistry"] boolValue] && (apiurl == nil ||  [apiurl isEqualToString:@"https://api.finogeeks.com"] ||  [apiurl isEqualToString:@"https://apit.finogeeks.com"]) ){
//        isShow = YES;
//    }
//    isShow = YES;
    if ([apiurl isEqualToString:@"https://api.finogeeks.com"] || [apiurl isEqualToString:@"http://api.finogeeks.com"]) {
        isShow = YES;
    } else {
        isShow = NO;
    }
    self.registerBtn.hidden = !isShow;
    self.forgetPwdBtn.hidden = !isShow;
    self.txtUsername.placeholder = isShow ? @"请输入用户名 / 手机号":@"用户名 / 手机号";
    self.txtPassword.placeholder = isShow ? @"请输入登录密码":@"请填写密码";
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


#pragma mark - Utils

- (void)p_bindViewModel {
    @weakify(self)
    RACSignal *validUserName = [[_txtUsername rac_textSignal]
                                map:^id (NSString * username) {
                                    return @(p_isUsernameValid(username));
                                }];
    
    RACSignal *validPassword = [[_txtPassword rac_textSignal]
                                map:^id (NSString * password) {
                                    return @(p_isPasswordValid(password));
                                }];
    
    
    [[RACSignal
      combineLatest:@[validUserName, validPassword]
      reduce:^id (NSNumber * userValid, NSNumber * passwordValid) {
          return @(userValid.boolValue && passwordValid.boolValue);
      }]
     subscribeNext:^(NSNumber * loginEnable) {
         self.loginBtn.enabled = loginEnable.boolValue;
         if (self.loginBtn.enabled) {
             self.loginBtn.backgroundColor = [UIColor fin_colorWithHexString:@"4285f4"];
         } else {
             self.loginBtn.backgroundColor = [UIColor fin_colorWithHexString:@"ced2d6"];
         }
     }];
    
    [[[[self.loginBtn
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(id x) {
            @strongify(self)
            self.loginBtn.enabled = NO;
            self.signInFailureText.hidden = YES;
        }]
        flattenMap:^id(id x) {
            return [self p_signInSignal];
        }]
        subscribeNext:^(NSDictionary *signedIn) {
            NSLog(@"clicked");
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loginBtn.enabled = YES;
                BOOL success = [signedIn[@"success"] boolValue];
                self.signInFailureText.hidden = success;
                if(!success){
                    self.signInFailureText.text = signedIn[@"errorInfo"];
                }
                if (success) {
                    [self.delegate loginSuccess];
                }
                
            });
        }];
}

- (RACSignal *)p_signInSignal {
    return [RACSignal createSignal:^RACDisposable* (id<RACSubscriber> subscriber) {
        [[FinoChatClient sharedInstance].finoAccountManager
         login:_txtUsername.text
         password:_txtPassword.text
         success:^(NSDictionary* ret) {
             [subscriber sendNext:@{
                                    @"success":@(YES)
                                    }];
             [subscriber sendCompleted];
         } failure:^(NSError *error) {
             NSLog(@"%@",error);
             [subscriber sendNext:@{
                                    @"success":@(NO),
                                    @"errorInfo":error.localizedDescription
                                    }];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

- (IBAction)registerClick:(id)sender {
    FCSetUserNameViewController* registervc = [[FCSetUserNameViewController alloc] init];
    [self.navigationController pushViewController:registervc animated:YES];
}

- (IBAction)forgetPwdClick:(id)sender {
    FCRegisterViewController* registervc = [[FCRegisterViewController alloc] init];
    registervc.type = FCRegisterViewControllerTypeForgetPwd;
    [self.navigationController pushViewController:registervc animated:YES];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}



BOOL p_isUsernameValid(NSString *username) {
    return [username length] >= 3;
}

BOOL p_isPasswordValid(NSString *pwd) {
    return [pwd length] >= 6;
}
- (void)btnSetting
{
//    FCSettingViewController* vc = [FCSettingViewController new];
    FCServerSettingSelectVC *vc = [[FCServerSettingSelectVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - getter/setter

- (UIBarButtonItem*)rightButton
{
    if(!_rightButton){
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"设置" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        //添加点击事件
        [button addTarget:self action:@selector(btnSetting) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    return _rightButton;
}
@end
