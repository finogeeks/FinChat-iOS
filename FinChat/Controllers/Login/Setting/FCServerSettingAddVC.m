//
//  FCServerSettingAddVC.m
//  FINAMAC
//
//  Created by xujiaqiang on 2018/11/20.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "FCServerSettingAddVC.h"
#import "FCQRCodeScanningViewController.h"
#import "FCService.h"
#import "FCHUD.h"
#import "UIColor+Fino.h"
#import "FCUIHelper.h"

#import <Masonry.h>
#import <FinChatSDK/FinoChat.h>

NSString *const kFinchatCustomServerUrlArray = @"FinchatCustomServerUrlArray";

@interface FCServerSettingAddVC ()<UITextFieldDelegate, QRCodeDelegate>

@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *urlField;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) NSMutableArray *customUrlArray;
@end

@implementation FCServerSettingAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self fin_addRightBarButton];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewTapAction)];
    [self.view addGestureRecognizer:gesture];
    self.customUrlArray = [FCServerSettingAddVC getArchiveObjectWithName:kFinchatCustomServerUrlArray];
    if (self.customUrlArray == nil) {
        self.customUrlArray = [[NSMutableArray alloc] init];
    }
    
    self.title = @"新增服务器";
    if (self.serverInfoDict) {
        self.nameField.text = self.serverInfoDict[@"server_name"];
        self.urlField.text = self.serverInfoDict[@"server_address"];
        self.title = @"编辑服务器";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarStyle = FINStatusBarStyle;
}

-(void) tapViewTapAction {
    [self.view endEditing:YES];
}

- (void)fin_addRightBarButton
{
    UIImage *img = [FCUIHelper fin_imageWithTintColor:FINThemeNormalColor image:[UIImage imageNamed:@"sdk_login_nav_ic_scan"]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(fin_scan)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)fin_scan {
    FCQRCodeScanningViewController *scanVC = [FCQRCodeScanningViewController new];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void) createUI{
    self.view.backgroundColor = [UIColor fin_colorWithHexString:@"#F6F6F6"];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.height.mas_equalTo(96);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor fin_colorWithHexString:@"333333"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.text = @"名称";
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.top.equalTo(bgView).offset(12);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    self.nameField = [UITextField new];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入名称" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"PingFangSC-Regular" size:17],NSForegroundColorAttributeName:[UIColor fin_colorWithHexString:@"c7c7c7"]}];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.textColor = [UIColor fin_colorWithHexString:@"333333"];
    self.nameField.textAlignment = NSTextAlignmentLeft;
    self.nameField.tintColor =[UIColor fin_colorWithHexString:@"b3c4f8"];
    self.nameField.font = [UIFont systemFontOfSize:17];
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.delegate = self;
    [bgView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel).offset(50);
        make.right.equalTo(bgView).offset(-15);
        make.height.centerY.equalTo(nameLabel);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor fin_colorWithHexString:@"#EDEDEC"];
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.right.centerY.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *urlLabel = [UILabel new];
    urlLabel.textColor = [UIColor fin_colorWithHexString:@"333333"];
    urlLabel.textAlignment = NSTextAlignmentLeft;
    urlLabel.font = [UIFont systemFontOfSize:17];
    urlLabel.text = @"URL";
    [bgView addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.bottom.equalTo(bgView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    self.urlField = [UITextField new];
    self.urlField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入URL" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"PingFangSC-Regular" size:17],NSForegroundColorAttributeName:[UIColor fin_colorWithHexString:@"c7c7c7"]}];
    self.urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.urlField.textColor = [UIColor fin_colorWithHexString:@"333333"];
    self.urlField.textAlignment = NSTextAlignmentLeft;
    self.urlField.tintColor =[UIColor fin_colorWithHexString:@"b3c4f8"];
    self.urlField.font = [UIFont systemFontOfSize:17];
    self.urlField.returnKeyType = UIReturnKeyDone;
    self.urlField.keyboardType = UIKeyboardTypeURL;
    self.urlField.delegate = self;
    [bgView addSubview:self.urlField];
    [self.urlField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(urlLabel).offset(50);
        make.right.equalTo(bgView).offset(-15);
        make.height.centerY.equalTo(urlLabel);
    }];
    [self.nameField addTarget:self action:@selector(handleTextFieldValueChangedEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.urlField addTarget:self action:@selector(handleTextFieldValueChangedEvent:) forControlEvents:UIControlEventEditingChanged];
    
    self.submitBtn = [[UIButton alloc] init];
    [self.submitBtn setTitle:@"验证并保存" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = [UIColor fin_colorWithHexString:@"#ced2d6"];
    self.submitBtn.layer.cornerRadius = 3.0f;
    self.submitBtn.clipsToBounds = YES;
    self.submitBtn.enabled = NO;
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(bgView.mas_bottom).offset(30);
        make.height.mas_equalTo(47);
    }];
    [self.submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.backgroundColor = FINThemeDisableColor;
}

-(BOOL)isEmpty:(NSString *)str {
    if ((NSNull*)str == [NSNull null] || str == nil || [self equal:@"null" str:str] || [self equal:@"(null)" str:str] || [[str stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        return YES;
    }
    return NO;
}

-(BOOL)isNotEmpty:(NSString *)str {
    return ![self isEmpty:str];
}
-(BOOL)equal:(NSString *)str1 str:(NSString *)str2 {
    if (str1 == str2 || [str1 isEqualToString:str2]) {
        return YES;
    }
    return NO;
}
- (void)handleTextFieldValueChangedEvent: (UITextField *)sender {
    if ([self isNotEmpty:self.nameField.text] && [self isNotEmpty:self.urlField.text]) {
        self.submitBtn.backgroundColor = FINThemeNormalColor;
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.backgroundColor = FINThemeDisableColor;
        self.submitBtn.enabled = NO;
    }
}
-(void)submitBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BOOL originEnabled = self.submitBtn.enabled;
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = FINThemeDisableColor;
    NSString *name = self.nameField.text;
    [FCHUD showLoadingWithMessage:@"保存中..."];
    if (name.length == 0) {
        [FCHUD showTipsWithMessage:@"请输入新增服务器地址名称"];
        self.submitBtn.enabled = originEnabled;
        self.submitBtn.backgroundColor = originEnabled ? FINThemeNormalColor:FINThemeDisableColor;
        return;
    }
    
    NSString *url = [self.urlField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *regex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if(![pred evaluateWithObject:url]) {
        [FCHUD showTipsWithMessage:@"服务器地址不正确\nhttp[s]://***.***"];
        self.submitBtn.enabled = originEnabled;
        self.submitBtn.backgroundColor = originEnabled ? FINThemeNormalColor:FINThemeDisableColor;
        return;
    }
    
    // 如果是编辑服务器地址，则先将旧地址删除
    BOOL isEdit = (self.serverInfoDict != nil);
    if (isEdit) {
        for (NSDictionary *info in self.customUrlArray) {
            NSString *serverUrl = info[@"server_address"];
            NSString *editUrl = self.serverInfoDict[@"server_address"];
            if ([serverUrl isEqualToString:editUrl]) {
                [self.customUrlArray removeObject:info];
                [FCServerSettingAddVC saveArchiveObject:self.customUrlArray name:kFinchatCustomServerUrlArray];
                break;
            }
        }
    }
    
    for (NSDictionary *dict in self.customUrlArray) {
        NSString *serverURL = dict[@"server_address"];
        if ([serverURL isEqualToString:url]) {
            [FCHUD showTipsWithMessage:@"本地已存在相同地址"];
            self.submitBtn.enabled = originEnabled;
            self.submitBtn.backgroundColor = originEnabled ? FINThemeNormalColor:FINThemeDisableColor;
            return ;
        }
    }
    
    [[FinoChatClient sharedInstance].finoAccountManager checkValidServer:url success:^{
        // 校验通过，保存地址
        NSDictionary *dic = @{@"server_name":name,@"server_address":url};
        [self.customUrlArray addObject:dic];
        [FCServerSettingAddVC saveArchiveObject:self.customUrlArray name:kFinchatCustomServerUrlArray];
        if (isEdit) {
            [FCHUD showTipsWithMessage:@"修改成功"];
        } else {
            [FCHUD showTipsWithMessage:@"添加成功"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.submitBtn.enabled = originEnabled;
        self.submitBtn.backgroundColor = originEnabled ? FINThemeNormalColor:FINThemeDisableColor;
    } failure:^(NSError *error) {
        [FCHUD showTipsWithMessage:@"URL地址有误，请核对后重新输入"];
        self.submitBtn.enabled = originEnabled;
        self.submitBtn.backgroundColor = originEnabled ? FINThemeNormalColor:FINThemeDisableColor;
    }];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == self.nameField) {
        [self.urlField becomeFirstResponder];
    }
    return NO;
}

#pragma mark - QRCodeDelegate
- (void)setQRResult:(NSString *)result
{
    self.urlField.text = result;
    
    [self handleTextFieldValueChangedEvent:nil];
}

#pragma mark - 归档方法
//保存数据
+ (void)saveArchiveObject:(id)object name:(NSString *)name{
    
    NSString * path = [[FCServerSettingAddVC pathCaches] stringByAppendingPathComponent:name];
    [NSKeyedArchiver archiveRootObject:object toFile:path];
}
//取出数据
+ (id)getArchiveObjectWithName:(NSString *)name{
    
    NSString * path = [[FCServerSettingAddVC pathCaches] stringByAppendingPathComponent:name];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return obj;
}
//清空数据
+ (void)emptyArchiveObjectWithName:(NSString *)name{
    
    NSArray * arr = [[NSArray alloc] init];
    NSString * path = [[FCServerSettingAddVC pathCaches] stringByAppendingPathComponent:name];
    [NSKeyedArchiver archiveRootObject:arr toFile:path];
}
+ (NSString *)pathCaches{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
