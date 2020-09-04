//
//  FINNewPasswordViewController.m
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import "FCNewPasswordViewController.h"
#import "FCUIHelper.h"
#import "FCHUD.h"

#import <FinChatSDK/FinoChatConst.h>
#import <FinChatSDK/FinoChat.h>

@interface FCNewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *visibilityBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *smsCode;

@end

@implementation FCNewPasswordViewController

- (instancetype)initWithPhone:(NSString *)phone smsCode:(NSString *)code
{
    if (self = [super init]) {
        _phone = phone;
        _smsCode = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fin_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self fin_addTextFiledObserver];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fin_setupUI
{
    self.resetPwdBtn.enabled = NO;
    self.resetPwdBtn.backgroundColor = FINThemeDisableColor;
    
    [self.backBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    UIImage *themeImg = [FCUIHelper fin_imageWithTintColor:FINThemeNormalColor image:[UIImage imageNamed:@"public_back_blue"]];
    [self.backBtn setImage:themeImg forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)fin_addTextFiledObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // `下一步`按钮状态控制
        if (self.passwordTF.text.length >= 6) {
            
            self.resetPwdBtn.enabled = YES;
            self.resetPwdBtn.backgroundColor = FINThemeNormalColor;
        } else {
            
            self.resetPwdBtn.enabled = NO;
            self.resetPwdBtn.backgroundColor = FINThemeDisableColor;
        }
    }];
}

#pragma mark - Actions
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setPasswordVisible:(id)sender {
    self.visibilityBtn.selected = !self.visibilityBtn.isSelected;
    if (self.visibilityBtn.isSelected) {
        self.passwordTF.secureTextEntry = NO;
    } else {
        self.passwordTF.secureTextEntry = YES;
    }
}

- (IBAction)resetPassword:(id)sender {
    
    static double oldtime = 0;
    double nowtime = [[NSDate date] timeIntervalSince1970];
    //限制3秒内只能点击一次有效，防止多次点击后跳出多个VC的问题
    if ((nowtime - oldtime) < 2) {
        return;
    }
    
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //重置密码
    __weak typeof(self) weakSelf = self;
    [FCHUD showLoadingWithMessage:@"正在修改密码"];
    [[FinoChatClient sharedInstance].finoAccountManager resetPwdWithPhone:self.phone smsCode:self.smsCode newPwd:password success:^{

        [FCHUD showTipsWithMessage:@"修改密码成功"];
        [weakSelf login];
    } failure:^(NSError *error) {
        
        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];
}

- (void)login
{
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [[FinoChatClient sharedInstance].finoAccountManager login:self.phone password:password success:^(NSDictionary* ret) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinoChatLoginSuccessNotification object:nil];
    } failure:^(NSError *error) {
        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];

}
@end
