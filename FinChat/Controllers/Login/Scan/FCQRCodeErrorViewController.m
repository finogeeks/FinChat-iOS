//
//  FINQRCodeErrorViewController.m
//  FinoConversation
//
//  Created by Patrick on 2019/5/20.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import "FCQRCodeErrorViewController.h"
#import "UIColor+Fino.h"

#import <Masonry.h>

@interface FCQRCodeErrorViewController ()

@property (nonatomic, strong) UIImageView *errorIV;
@property (nonatomic, strong) UILabel *errorLbl;

@end

@implementation FCQRCodeErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fin_setupUI];
}

- (void)fin_setupUI
{
    self.view.backgroundColor = [UIColor fin_colorWithHexString:@"#F0F1F4"];
    
    self.errorIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sdk_error_qr"]];
    [self.view addSubview:self.errorIV];
    [self.errorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(165);
        make.width.height.mas_equalTo(77);
        make.centerX.mas_equalTo(self.view);
    }];
    
    self.errorLbl = [UILabel new];
    self.errorLbl.text = @"该二维码无法识别";
    self.errorLbl.textColor = [UIColor fin_colorWithHexString:@"#9B9B9B"];
    [self.view addSubview:self.errorLbl];
    [self.errorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.errorIV.mas_bottom).mas_offset(19);
        make.centerX.mas_equalTo(self.view);
    }];
}
@end
