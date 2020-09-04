//
//  FINNewSplashViewController.m
//  FinoChat
//
//  Created by 潘老6 on 2017/12/5.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FINNewSplashViewController.h"
#import "FINMainController.h"
#import "YYImage.h"
#import <Masonry.h>
#import "FCUIHelper.h"

@implementation FINNewSplashViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *orientation = @"Portrait";
    NSString *imageName = nil;
    
    NSArray *imageArray = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imageArray) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        NSString *imageOrientation = dict[@"UILaunchImageOrientation"];
        if (CGSizeEqualToSize(screenSize, imageSize) && [orientation isEqualToString:imageOrientation]) {
            imageName = dict[@"UILaunchImageName"];
        }
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    NSString *loadingName = @"loading-animate";
    YYImage *loadingImage = [YYImage imageNamed:loadingName];
    YYAnimatedImageView *gifImageView = [[YYAnimatedImageView alloc] initWithImage:loadingImage];
    [self.view addSubview:gifImageView];
    [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
}

@end













