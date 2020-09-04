//
//  FCSettingViewController.m
//  FinoChat
//
//  Created by 杨涛 on 2017/12/27.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FCSettingViewController.h"
#import "FCQRCodeScanningViewController.h"
#import "UIColor+Fino.h"
#import "FCService.h"
#import "FCHUD.h"

#import <FinChatSDK/FinoChat.h>
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface FCSettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtServerURL;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation FCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.txtServerURL.text = [userDefaults stringForKey:@"finochat_apiurl"];
    
    self.btn.layer.cornerRadius = 5;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:UIBarButtonItemStylePlain target:self action:@selector(btnScan:)];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)fin_checkBtnVailed {
    self.btn.enabled = self.txtServerURL.text.length > 0;
    NSString* btnStr = self.btn.enabled ? @"4285f4" :@"ced2d6";
    self.btn.backgroundColor = [UIColor fin_colorWithHexString:btnStr];
}

#pragma mark - click events
- (void)btnScan:(id)sender{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!granted) {
                [self fin_showAlert:@"无法访问您的相机" message:@"请到设置 -> 隐私 -> 相机 ，打开访问权限" completion:nil];
                return ;
            }
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [FCHUD showTipsWithMessage:@"设备不支持摄像头"];
                return;
            }
            FCQRCodeScanningViewController *vc = [[FCQRCodeScanningViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
}

- (IBAction)textFieldChanged:(id)sender
{
    [self fin_checkBtnVailed];
}

- (IBAction)btnOK:(id)sender
{
    [self.view endEditing:YES];
    NSString *url = self.txtServerURL.text;
    NSString *regex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if(![pred evaluateWithObject:url]) {
        [FCHUD showTipsWithMessage:@"服务器地址不正确\nhttp[s]://***.***"];
        return;
    }
    
    [[FinoChatClient sharedInstance].finoAccountManager checkValidServer:url success:^{
        // 校验通过，保存地址
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.txtServerURL.text forKey:@"finochat_apiurl"];
        [userDefaults synchronize];
        // 更新session
//        [[FCService sharedInstance] initSession:nil onProgress:nil failure:nil];
        [[FCService sharedInstance] initSDK:nil];
        // 给予提示
        [FCHUD showTipsWithMessage:@"服务器地址设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [FCHUD showTipsWithMessage:@"URL地址有误，请核对后重新输入"];
    }];
}


#pragma mark - QRCodeDelegate
- (void)setQRResult:(NSString *)result
{
    self.txtServerURL.text = result;
    [self fin_checkBtnVailed];
}

#pragma mark - tool method
- (void)fin_showAlert:(NSString*)title message:(NSString*)message completion:(void (^)(void))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completion)
            completion();
    }]];
    [self presentViewController:alert animated:true completion:nil];
}


@end
