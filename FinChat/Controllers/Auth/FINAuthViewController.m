//
//  FINAuthViewController.m
//  FinChat
//
//  Created by Patrick on 2019/3/21.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import "FINAuthViewController.h"

#import <FinChatSDK/FINServiceFactory.h>

@interface FINAuthViewController ()

@end

@implementation FINAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)fin_auth:(id)sender {
    NSString *userId = [FINServiceFactory sharedInstance].currentUserId;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:%@", self.reDirectUrl, userId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
