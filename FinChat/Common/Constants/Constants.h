//
//  Constants.h
//  FinoChat
//
//  Created by 杨涛 on 2017/11/9.
//  Copyright © 2017年 finogeeks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/// The total animation duration of the splash animation
UIKIT_EXTERN const NSTimeInterval kAnimationDuration;
/// The length of the second part of the duration
UIKIT_EXTERN const NSTimeInterval kAnimationDurationDelay;
/// The offset between the AnimatedULogoView and the background Grid
UIKIT_EXTERN const NSTimeInterval kAnimationTimeOffset;
/// The ripple magnitude. Increase by small amounts for amusement ( <= .2) :]
UIKIT_EXTERN const NSTimeInterval kRippleMagnitudeMultiplier;

UIKIT_EXTERN NSString *const kFCNotificationLoginSuccess;

#define UberBlue [UIColor colorWithRed:70/255.0 green:136/255.0 blue:240/255.0 alpha:1.0]
#define UberLightBlue [UIColor colorWithRed:70/255.0 green:136/255.0 blue:240/255.0 alpha:1.0]

#define DELAYRUN(t,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), block)


UIKIT_EXTERN NSString *const kIssuer;
UIKIT_EXTERN NSString *const kClientId;
UIKIT_EXTERN NSString *const kRedirectURI;
UIKIT_EXTERN NSString *const kFINAuthToken;

UIKIT_EXTERN NSString *const kFINLoginAccount;
