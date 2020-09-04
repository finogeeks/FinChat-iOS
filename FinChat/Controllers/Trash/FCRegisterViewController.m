//
//  FCRegisterViewController.m
//  FinoChat
//
//  Created by zhao on 2017/12/19.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FCRegisterViewController.h"
#import "FCSetUserNameViewController.h"
#import "UIColor+Fino.h"
#import <FinChatSDK/FinoChat.h>
#import "FCHUD.h"

@interface FCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLabel;

@property (nonatomic, strong) NSTimer* timer;
@end

@implementation FCRegisterViewController
static int count = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fin_setupUIWithType:self.type];
    [self fin_addGesture];
    // Do any additional setup after loading the view from its nib.
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    count = 60;
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateHighlighted];
    self.sendCodeBtn.userInteractionEnabled = YES;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - action

- (IBAction)sendCodeBtnClick:(id)sender {
    
    [[FinoChatClient sharedInstance].finoAccountManager getPhoneSmsCode:self.phoneNumTextField.text success:^{
        NSLog(@"获取验证码成功");
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fin_updateBtnTitle) userInfo:nil repeats:YES];
        self.sendCodeBtn.userInteractionEnabled = NO;
        self.errorMsgLabel.hidden = YES;
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
        [self fin_setupErrorLabel:error.localizedDescription];
    }];
}

- (IBAction)showPwdBtnClick:(id)sender {
    self.pwdTextField.secureTextEntry = !self.pwdTextField.secureTextEntry;
    //换图
    if (self.pwdTextField.secureTextEntry) {
        [self.showPwdBtn setImage:[UIImage imageNamed:@"ic-eyes-closed"] forState:UIControlStateNormal];
    } else {
        [self.showPwdBtn setImage:[UIImage imageNamed:@"ic-eyes"] forState:UIControlStateNormal];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    if (self.type == FCRegisterViewControllerTypeRegister) {
        //验证手机验证码
        [[FinoChatClient sharedInstance].finoAccountManager verifyPhoneSmsCode:self.phoneNumTextField.text smsCode:self.codeTextField.text success:^{
            weakSelf.errorMsgLabel.hidden = YES;
            //设置昵称页面
            FCSetUserNameViewController* userNameVC = [[FCSetUserNameViewController alloc] init];
            userNameVC.phoneNum = weakSelf.phoneNumTextField.text;
            userNameVC.smsCode = weakSelf.codeTextField.text;
            userNameVC.pwd = weakSelf.pwdTextField.text;
            [weakSelf.navigationController pushViewController:userNameVC animated:YES];
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error.localizedDescription);
            [weakSelf fin_setupErrorLabel:error.localizedDescription];
        }];
    } else if (self.type == FCRegisterViewControllerTypeForgetPwd) {
        //重置密码
        [[FinoChatClient sharedInstance].finoAccountManager resetPwdWithPhone:self.phoneNumTextField.text smsCode:self.codeTextField.text newPwd:self.pwdTextField.text success:^{
            NSLog(@"reset pwd success");
            weakSelf.errorMsgLabel.hidden = YES;
//            [FCSimpleToastView makeSimpleToast:@"修改密码成功" inSeconds:1.5];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error.localizedDescription);
            [weakSelf fin_setupErrorLabel:error.localizedDescription];
        }];
    }
}

- (IBAction)phoneTextChanged:(id)sender {
    [self fin_checkBtnVailed];
}

- (IBAction)codeTextChaghed:(id)sender {
    [self fin_checkBtnVailed];
}

- (IBAction)pwdTextChanged:(id)sender {
    [self fin_checkBtnVailed];
    if (self.pwdTextField.text.length > 12) {
        //截取前12位
        self.pwdTextField.text = [self.pwdTextField.text substringToIndex:12];
        //提示最多12位
        [self fin_setupErrorLabel:@"密码长度不正确(6-16位)"];
    }
}



#pragma mark - private
- (void)fin_setupUIWithType:(FCRegisterViewControllerType)type {
    if (type == FCRegisterViewControllerTypeRegister) {
        self.title = @"手机号注册";
        [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    } else if (type == FCRegisterViewControllerTypeForgetPwd) {
        self.title = @"重置登录密码";
        [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"确认" forState:UIControlStateHighlighted];
    }
}

- (void)fin_checkBtnVailed {
    self.errorMsgLabel.hidden = YES;
    self.sendCodeBtn.enabled = self.phoneNumTextField.text.length > 0;
    self.confirmBtn.enabled = (self.phoneNumTextField.text.length > 0 && self.codeTextField.text.length && self.pwdTextField.text.length >= 6 && self.pwdTextField.text.length <= 16);
    NSString* btnStr = self.confirmBtn.enabled ? @"4285f4" :@"ced2d6";
    self.confirmBtn.backgroundColor = [UIColor fin_colorWithHexString:btnStr];
}

- (void)fin_setupErrorLabel:(NSString*)title {
    self.errorMsgLabel.hidden = NO;
    self.errorMsgLabel.text = title;
}

- (void)fin_updateBtnTitle {
    count--;
    if (count <= 0) {
        [self.sendCodeBtn setTitleColor:[UIColor fin_colorWithHexString:@"4285f4"] forState:UIControlStateNormal];
        [self.sendCodeBtn setTitleColor:[UIColor fin_colorWithHexString:@"4285f4"] forState:UIControlStateHighlighted];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateHighlighted];
        [self.timer invalidate];
        self.sendCodeBtn.userInteractionEnabled = YES;
        count = 60;
    } else {
        [self.sendCodeBtn setTitleColor:[UIColor fin_colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        [self.sendCodeBtn setTitleColor:[UIColor fin_colorWithHexString:@"bbbbbb"] forState:UIControlStateHighlighted];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"重新发送%d",count] forState:UIControlStateNormal];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"重新发送%d",count] forState:UIControlStateHighlighted];
    }
}

- (void)fin_addGesture {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fin_hideKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)fin_hideKeyboard {
    [self.view endEditing:YES];
}


@end
