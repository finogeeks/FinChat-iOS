//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/FCQRCode.git
//
//  FCQRCodeHelperTool.m
//  FCQRCodeExample
//
//  Created by kingsic on 2017/8/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "FCQRCodeHelperTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation FCQRCodeHelperTool
/** 打开手电筒 */
+ (void)FC_openFlashlight {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch]) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            captureDevice.torchMode = AVCaptureTorchModeOn;
            [captureDevice unlockForConfiguration];
        }
    }
}
/** 关闭手电筒 */
+ (void)FC_CloseFlashlight {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}


@end
