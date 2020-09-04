//
//  ShareViewController.m
//  finshare
//
//  Created by 杨涛 on 2018/1/30.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "ShareViewController.h"
#import <FinChatSDK/FinoChat.h>
#import <FinChatSDK/FINServiceFactory.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    
    NSString* urlSchemaPrefix = @"finchat";
    NSDictionary* settings = [FINServiceFactory sharedInstance].sessionManager.options.config.settings;
    if (settings && settings[@"urlSchemaPrefix"]) {
        urlSchemaPrefix =settings[@"urlSchemaPrefix"];
    }
    
#ifdef FIN_INTERNAL
    [[FinoChatClient sharedInstance].finoShareManager initialize:@{
                                                                   @"appGroupIdentifier":@"group.com.finogeeks.finchat.oa",
                                                                   @"appTypeUrlSchemes":urlSchemaPrefix
                                                                   }];
#else
    [[FinoChatClient sharedInstance].finoShareManager initialize:@{
                                                                   @"appGroupIdentifier":@"group.com.finogeeks.finchat",
                                                                   @"appTypeUrlSchemes":urlSchemaPrefix
                                                                   }];
#endif
    
    [super viewDidLoad];
    
    [[FinoChatClient sharedInstance].finoShareManager setExtensionContext:self.extensionContext];
    UIViewController *vc = [[FinoChatClient sharedInstance].finoShareManager getShareViewController];
    //
    if (vc != nil) {
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
