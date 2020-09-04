//
//  FINPhoneVerifyViewController.h
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FCPhoneVerifyType) {
    FCPhoneVerifyType_Register,
    FCPhoneVerifyType_ResetPassword
};

@interface FCPhoneVerifyViewController : UIViewController

- (instancetype)initWithVerifyType:(FCPhoneVerifyType)type;
@end

NS_ASSUME_NONNULL_END
