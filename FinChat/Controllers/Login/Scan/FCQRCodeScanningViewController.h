//
//  FINQRCodeScanningViewController.h
//  FinoConversation
//
//  Created by 杨涛 on 2017/12/31.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeDelegate <NSObject>

@required
- (void)setQRResult:(NSString*) result;

@end

@interface FCQRCodeScanningViewController : UIViewController

@property (weak, nonatomic) id<QRCodeDelegate> delegate;

@end

