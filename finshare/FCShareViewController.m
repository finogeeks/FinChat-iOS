//
//  FCShareViewController.m
//  shareExtension
//
//  Created by 杨涛 on 2017/11/22.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import "FCShareViewController.h"
#import <FinoChat.h>
@interface FCShareViewController ()

@end

@implementation FCShareViewController

- (void)viewDidLoad {
    [[FinoChatClient sharedInstance].finoShareManager initialize:@{@"appGroupIdentifier":@"group.com.finogeeks.finochat"}];
    [[FinoChatClient sharedInstance].finoShareManager setExtensionContext:self.extensionContext];
    [super viewDidLoad];
    UIViewController* vc =[[FinoChatClient sharedInstance].finoShareManager getShareViewController];
//
    if(vc!=nil)
        [self.navigationController pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
