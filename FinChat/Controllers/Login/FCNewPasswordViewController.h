//
//  FINNewPasswordViewController.h
//  FinChat
//
//  Created by Patrick on 2018/12/20.
//  Copyright © 2018 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCNewPasswordViewController : UIViewController

- (instancetype)initWithPhone:(NSString *)phone smsCode:(NSString *)code;
@end

NS_ASSUME_NONNULL_END
