//
//  FCSetUserNameViewController.m
//  FinoChat
//
//  Created by zhao on 2017/12/19.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FCSetUserNameViewController.h"
#import "UIColor+Fino.h"
#import <FinChatSDK/FinoChat.h>
#import "FCService.h"
#import "FCUserAgreementViewController.h"

//#import "FCSimpleToastView.h"

@interface FCSetUserNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (nonatomic, strong) NSTimer* timer;



@end

@implementation FCSetUserNameViewController
static int count = 60;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号注册";
    [self fin_addGesture];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.userNameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
    [self fin_checkBtnVailed];
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
- (IBAction)namaTextFieldChanged:(id)sender {
    [self fin_checkBtnVailed];
    if (self.userNameTextField.text.length > 22) {
        self.userNameTextField.text = [self.userNameTextField.text substringToIndex:16];
        //提示
        [self fin_setupErrorLabel:@"昵称长度不能超过22位!"];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    BOOL ret = [self fin_checkUserNameAvailable];
    if (!ret) {
        return ;
    }
    [[FinoChatClient sharedInstance].finoAccountManager registerAccountWith:self.phoneNumTextField.text smsCode:self.codeTextField.text pwd:self.pwdTextField.text displayname:self.userNameTextField.text success:^{
        NSLog(@"register account success");
        self.errorMsgLabel.hidden = YES;
        [self fin_setupErrorLabel:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
        [self fin_setupErrorLabel:error.localizedDescription];
    }];
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

- (IBAction)openAgreement:(id)sender {
    
    NSString *baseURL = [[FCService sharedInstance] serverURLStr];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/agreement/", baseURL]];
    if (!url) {
        return ;
    }
    UIViewController *vc = [[FinoChatClient sharedInstance].finoChatUIManager webViewWithURL:@{@"url": url}];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userNameTextField) {
        [self fin_checkUserNameAvailable];
    } else if (textField == self.phoneNumTextField) {
        [self fin_checkPhoneAvailable];
    }
}

#pragma mark - private

- (void)fin_checkBtnVailed {
    self.errorMsgLabel.hidden = YES;
    self.sendCodeBtn.enabled = self.phoneNumTextField.text.length > 0;
    self.confirmBtn.enabled = ((self.userNameTextField.text.length > 0 && self.userNameTextField.text.length <= 22) && self.phoneNumTextField.text.length > 0 && self.codeTextField.text.length && self.pwdTextField.text.length >= 6 && self.pwdTextField.text.length <= 16);
    self.confirmBtn.userInteractionEnabled = self.confirmBtn.enabled;
    NSString* btnStr = self.confirmBtn.userInteractionEnabled ? @"4285f4" :@"ced2d6";
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
    
#pragma mark - Data Request
- (BOOL)fin_checkUserNameAvailable
{
    NSString *string = self.userNameTextField.text;
//    if (string.length < 5 || string.length > 16) {
//        [FCSimpleToastView makeSimpleToast:@"用户名长度5-22位" inSeconds:1.5];
//        return NO;
//    }
//    char commitChar = [string characterAtIndex:0];
//    if( commitChar > 64 && commitChar < 91){
//        [FCSimpleToastView makeSimpleToast:@"用户名首位须为小写字母" inSeconds:1.5];
//        return NO;
//    }
//    
//    NSString *regex = @"^[a-z]+[_a-z0-9.]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![predicate evaluateWithObject:string]){
//        [FCSimpleToastView makeSimpleToast:@"含有大写字或异常字符，请重新输入" inSeconds:1.5];
//        return NO;
//    }
    
//    NSString *str = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[FinoChatClient sharedInstance].finoAccountManager checkUserNameAvailable:str success:^(NSDictionary *response) {
//        NSInteger statusCode = [response[@"status"] integerValue];
//        if (statusCode == 200) {
//            NSLog(@"用户名可用");
//        } else if (statusCode == 409) {
//            [FCSimpleToastView makeSimpleToast:@"用户名已存在" inSeconds:1.5];
//        }
//    } failure:^(NSError *error) {
//
//    }];
    return YES;
}
    

- (void)fin_checkPhoneAvailable
{
    NSString *str = [self.phoneNumTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[FinoChatClient sharedInstance].finoAccountManager checkPhoneAvailable:str success:^(NSDictionary *response) {
        NSInteger statusCode = [response[@"status"] integerValue];
        if (statusCode == 200) {
            NSLog(@"手机号码可用");
        } else if (statusCode == 409) {
//            [FCSimpleToastView makeSimpleToast:@"手机号码已存在" inSeconds:1.5];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
