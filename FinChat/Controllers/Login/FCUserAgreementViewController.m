//
//  FCUserAgreementViewController.m
//  FinoChat
//
//  Created by zhao on 2017/12/29.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FCUserAgreementViewController.h"
#import <Masonry.h>

@interface FCUserAgreementViewController ()

@property (nonatomic, strong)UIWebView* webView;
@end

@implementation FCUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self fin_loadLocalImage];
}


- (void)fin_loadLocalImage {
    //编码图片
    UIImage *selectedImage = [UIImage imageNamed:@"agreement"];
    NSString *stringImage = [self htmlForJPGImage:selectedImage];
    
    //构造内容
    NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
    NSString *content =[NSString stringWithFormat:
                        @"<html>"
                        "<body>"
                        "%@"
                        "</body>"
                        "</html>"
                        , contentImg];

    [self.webView loadHTMLString:content baseURL:nil];
}

//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:0]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
