//
//  FINRegisterViewController.m
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import "FCRegisterViewController.h"
#import "UIImage+Fino.h"
#import "UIColor+Fino.h"
#import "FCHUD.h"
#import "FCService.h"
#import "FCUIHelper.h"

#import <FinChatSDK/FinoChat.h>
#import <Masonry.h>

@interface FCRegisterViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *smsCode;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *visibilityBtn;

@property (assign, nonatomic) BOOL needAnimation;

@property (strong, nonatomic) UIButton *agreementCheckBtn;
@property (strong, nonatomic) UILabel *agreementCheckLabel;
@property (strong, nonatomic) UIButton *agreementContentBtn;


@end

@implementation FCRegisterViewController

- (instancetype)initWithPhone:(NSString *)phone smsCode:(NSString *)smsCode
{
    if (self = [super init]) {
        _phone = phone;
        _smsCode = smsCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fin_setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:self.needAnimation];
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

- (void)backgroundTap:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}

- (void)fin_setupUI
{
    self.registerBtn.enabled = NO;
    self.registerBtn.backgroundColor = FINThemeDisableColor;
    
    self.userNameTF.delegate = self;
    
    [self.backBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    UIImage *themeImg = [FCUIHelper fin_imageWithTintColor:FINThemeNormalColor image:[UIImage imageNamed:@"public_back_blue"]];
    [self.backBtn setImage:themeImg forState:UIControlStateNormal];
    
    self.agreementCheckLabel = [UILabel new];
    self.agreementCheckLabel.font = [UIFont systemFontOfSize:15];
    self.agreementCheckLabel.text = @"我已经阅读并同意";
    self.agreementCheckLabel.textColor = [UIColor blackColor];
    self.agreementCheckLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview: self.agreementCheckLabel];
    [self.agreementCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.view).offset(-50);
    }];
    
    self.agreementCheckBtn = [UIButton new];
    [self.agreementCheckBtn setImage:[UIImage imageNamed:@"sdk_login_unchecked"] forState:UIControlStateNormal];
    [self.agreementCheckBtn addTarget:self action:@selector(agreementCheckBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.agreementCheckBtn];
    [self.agreementCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.agreementCheckLabel.mas_left).offset(-10);
    }];
    
    self.agreementContentBtn = [UIButton new];
    self.agreementContentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.agreementContentBtn setTitle:@"FinChat用户使用协议" forState:UIControlStateNormal];
    [self.agreementContentBtn setTitleColor:FINThemeNormalColor forState:UIControlStateNormal];
    [self.agreementContentBtn addTarget:self action:@selector(agreementContentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.agreementContentBtn];
    [self.agreementContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.agreementCheckLabel.mas_right).offset(10);
    }];
}

- (void)agreementCheckBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agreementCheckBtn setImage:[UIImage imageNamed:@"sdk_login_seletced"] forState:UIControlStateSelected];
    } else {
        [self.agreementCheckBtn setImage:[UIImage imageNamed:@"sdk_login_unchecked"] forState:UIControlStateNormal];
    }
    [self updateRegisterBtnStatus];
}

- (void)agreementContentBtnAction:(UIButton *)sender {
    NSString *baseURL = [FINServiceFactory sharedInstance].sessionManager.options.config.finochatApiURL;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/agreement/index.html", baseURL]];
    if (!url) {
        return ;
    }
    UIViewController *webVC = [[FinoChatClient sharedInstance].finoChatUIManager webViewWithURL:@{@"url": url,@"source": @(6),}];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)fin_addTextFiledObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self updateRegisterBtnStatus];
    }];
}

- (void)updateRegisterBtnStatus {
    // `注册`按钮状态控制
    if (self.userNameTF.text.length >=5 && self.passwordTF.text.length >= 6 && self.agreementCheckBtn.selected == YES) {
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = FINThemeNormalColor;
    } else {
        
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = FINThemeDisableColor;
    }
}

- (BOOL)fin_checkUserNameAvailable
{
    NSString *string = self.userNameTF.text;
    if (string.length < 5 || string.length > 16) {
        [FCHUD showTipsWithMessage:@"用户名长度5-16位"];
        return NO;
    }
    char commitChar = [string characterAtIndex:0];
    if( commitChar > 64 && commitChar < 91){
        [FCHUD showTipsWithMessage:@"用户名首位须为小写字母"];
        return NO;
    }
    
    NSString *regex = @"^[a-z]+[_a-z0-9.]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:string]){
        [FCHUD showTipsWithMessage:@"含有大写字或异常字符，请重新输入"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.userNameTF) {
        if (textField.text.length >= 22) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userNameTF) {
        [self fin_checkUserNameAvailable];
//        NSString *string = self.userNameTF.text;
//        NSString *str = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[FinoChatClient sharedInstance].finoAccountManager checkUserNameAvailable:str success:^(NSDictionary *response) {
//            NSInteger statusCode = [response[@"status"] integerValue];
//            if (statusCode == 200) {
//
//            } else if (statusCode == 409) {
//                [FCHUD showTipsWithMessage:@"用户名已存在"];
//            }
//        } failure:^(NSError *error) {
//
//        }];
    }
}

#pragma mark - Actions
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setPwdVisiblity:(id)sender {
    self.visibilityBtn.selected = !self.visibilityBtn.isSelected;
    if (self.visibilityBtn.isSelected) {
        self.passwordTF.secureTextEntry = NO;
    } else {
        self.passwordTF.secureTextEntry = YES;
    }
}

- (IBAction)registerAccount:(id)sender {
    
    static double oldtime = 0;
    double nowtime = [[NSDate date] timeIntervalSince1970];
    //限制3秒内只能点击一次有效，防止多次点击后跳出多个VC的问题
    if ((nowtime - oldtime) < 2) {
        return;
    }
    
    [self.view endEditing:YES];
    if (![self fin_checkUserNameAvailable]) {
        return ;
    }
    
    // 去掉首尾的空格
    NSString *userName = [self.userNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [FCHUD showLoadingWithMessage:nil];
    __weak typeof(self) weakSelf = self;
    [[FinoChatClient sharedInstance].finoAccountManager registerAccountWith:self.phone smsCode:self.smsCode pwd:password displayname:userName success:^{
        
        [FCHUD showTipsWithMessage:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
        [FCHUD showTipsWithMessage:error.localizedDescription];
    }];
}

- (IBAction)openAggreement:(id)sender {
    NSString *baseURL = [[FCService sharedInstance] serverURLStr];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/agreement/", baseURL]];
    if (!url) {
        return ;
    }
    self.needAnimation = YES;
    UIViewController *vc = [[FinoChatClient sharedInstance].finoChatUIManager webViewWithURL:@{@"url": url}];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
