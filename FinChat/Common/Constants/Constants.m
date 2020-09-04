//
//  Constants.m
//  FinoChat
//
//  Created by 杨涛 on 2017/11/9.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import "Constants.h"

const NSTimeInterval kAnimationDuration = 3.0;
const NSTimeInterval kAnimationDurationDelay = 0.5;
const NSTimeInterval kAnimationTimeOffset = 0.35 * kAnimationDuration;
const NSTimeInterval kRippleMagnitudeMultiplier = 0.025;

NSString *const kFCNotificationLoginSuccess = @"kFCNotificationLoginSuccess";

NSString *const kIssuer = @"https://iam3.finogeeks.club:7777/auth/realms/master";
NSString *const kClientId = @"iosapp";
NSString *const kRedirectURI = @"iosapp://fake.url.here/auth";

NSString *const kFINAuthToken = @"kFINAuthToken";

NSString *const kFINLoginAccount = @"kFINLoginAccount";
