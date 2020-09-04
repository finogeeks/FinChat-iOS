//
//  FINPhoneVerifyViewController.m
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import "FCPhoneVerifyViewController.h"
#import "FCRegisterViewController.h"
#import "FCNewPasswordViewController.h"
#import "FCHUD.h"
#import "UIColor+Fino.h"
#import "UIImage+Fino.h"
#import <Masonry.h>

#import <FinChatSDK/FinoChat.h>

@interface FCPhoneVerifyViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, assign) FCPhoneVerifyType verifyType;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSInteger counter;

@end

@implementation FCPhoneVerifyViewController

- (instancetype)initWithVerifyType:(FCPhoneVerifyType)type
{
    if (self = [super init]) {
        _verifyType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.counter = 60;
    
    [self fin_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    self.sendCodeBtn.enabled = NO;
    [self.sendCodeBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    [self.sendCodeBtn setTitleColor:FINThemeDisableColor forState:UIControlStateDisabled];
    
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = FINThemeDisableColor;
    
    [self.cancelBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    
    self.phoneTF.delegate = self;

}

- (void)fin_addTextFiledObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self fin_nextBtnIsEnable];
    }];
}

- (void)fin_nextBtnIsEnable {
    // `发送验证码`按钮状态控制
    if ([self isMobilePhoneRegular:self.phoneTF.text]) {
        self.sendCodeBtn.enabled = YES;
    } else {
        self.sendCodeBtn.enabled = NO;
    }
    
    // `下一步`按钮状态控制
    if (self.phoneTF.text.length == 11 && self.smsCodeTF.text.length > 0) {
        
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = FINThemeNormalColor;
    } else {
        
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = FINThemeDisableColor;
    }
}

- (void)fin_verifyPhone
{
    NSString *str = [self.phoneTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[FinoChatClient sharedInstance].finoAccountManager checkPhoneAvailable:str success:^(NSDictionary *response) {
        NSInteger statusCode = [response[@"status"] integerValue];
        if (statusCode == 200) {
        } else if (statusCode == 409) {
            [FCHUD showTipsWithMessage:@"手机号码已存在"];
        }
    } failure:^(NSError *error) {
        if ([error.localizedDescription containsString:@"409"]) {
            [FCHUD showTipsWithMessage:@"手机号码已存在"];
        } else {
            [FCHUD showTipsWithMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 忘记密码不做验证
    if (self.verifyType == FCPhoneVerifyType_ResetPassword)
        return ;
    
    if (textField == self.phoneTF && [self isMobilePhoneRegular:textField.text]) {
        [self fin_verifyPhone];
    }
}

#pragma mark - Actions
- (IBAction)nextVC:(id)sender {
    
    static double oldtime = 0;
    double nowtime = [[NSDate date] timeIntervalSince1970];
    //限制3秒内只能点击一次有效，防止多次点击后跳出多个VC的问题
    if ((nowtime - oldtime) < 2) {
        return;
    }
    
    NSString *phone = [self.phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *code = [self.smsCodeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *type = @"register";
    if (self.verifyType == FCPhoneVerifyType_Register) {
        type = @"register";
    } else if (self.verifyType == FCPhoneVerifyType_ResetPassword) {
        type = @"forgetPwd";
    }
    
    // 验证手机
    __weak typeof(self) weakSelf = self;
    [[FinoChatClient sharedInstance].finoAccountManager verifyPhoneSmsCode:phone smsCode:code type:type success:^{

        if (weakSelf.verifyType == FCPhoneVerifyType_Register) {

            FCRegisterViewController *registerVC = [[FCRegisterViewController alloc] initWithPhone:phone smsCode:code];
            [weakSelf.navigationController pushViewController:registerVC animated:YES];
        } else if (weakSelf.verifyType == FCPhoneVerifyType_ResetPassword) {

            FCNewPasswordViewController *newPasswordVC = [[FCNewPasswordViewController alloc] initWithPhone:phone smsCode:code];
            [weakSelf.navigationController pushViewController:newPasswordVC animated:YES];
        }

    } failure:^(NSError *error) {

        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];
    
}

- (IBAction)cancelVerify:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendVerifyCode:(id)sender {
    // 去掉首尾的空格
    NSString *phone = [self.phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![self isMobilePhoneRegular:phone]) {
        [FCHUD showTipsWithMessage:@"手机号格式错误"];
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    [FCHUD showLoadingWithMessage:nil];
    [[FinoChatClient sharedInstance].finoAccountManager getPhoneSmsCode:phone success:^{
        
        [FCHUD showTipsWithMessage:@"获取验证码成功，请查看短信"];
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        weakSelf.sendCodeBtn.enabled = NO;
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fin_updateBtnTitle) userInfo:nil repeats:YES];
        
    } failure:^(NSError *error) {
        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];

}

- (void)fin_updateBtnTitle {
    self.counter--;
    if (self.counter <= 0) {
        
        [self.timer invalidate];
        self.sendCodeBtn.enabled = YES;
        self.counter = 60;
    } else {
    
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds后重新发送", (int)self.counter] forState:UIControlStateDisabled];
    }
}

- (BOOL)isMobilePhoneRegular:(NSString *)mobilePhone
{
    if (mobilePhone.length != 11) {
        return NO;
    }
    NSString *regex = @"^(1(([3456789][0-9])|(45)|(47)|(7[6-8])))\\d{8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:mobilePhone];
    return isValid;
}
@end
