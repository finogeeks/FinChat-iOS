//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/FCQRCode.git
//
//  FCQRCodeScanManager.h
//  FCQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class FCQRCodeScanManager;

@protocol FCQRCodeScanManagerDelegate <NSObject>

@required
/** 二维码扫描获取数据的回调方法 (metadataObjects: 扫描二维码数据信息) */
- (void)QRCodeScanManager:(FCQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects;
@optional
/** 根据光线强弱值打开手电筒的方法 (brightnessValue: 光线强弱值) */
- (void)QRCodeScanManager:(FCQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue;
@end

@interface FCQRCodeScanManager : NSObject
/** 快速创建单利方法 */
+ (instancetype)sharedManager;
/**  FCQRCodeScanManagerDelegate */
@property (nonatomic, weak) id<FCQRCodeScanManagerDelegate> delegate;

/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置，必须实现的方法
 *
 *  @param sessionPreset    会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 *  @param currentController      FCQRCodeScanManager 所在控制器
 */
- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController;
/** 开启会话对象扫描 */
- (void)startRunning;
/** 停止会话对象扫描 */
- (void)stopRunning;
/** 移除 videoPreviewLayer 对象 */
- (void)videoPreviewLayerRemoveFromSuperlayer;
/** 播放音效文件 */
- (void)palySoundName:(NSString *)name;
/** 重置根据光线强弱值打开手电筒的 delegate 方法 */
- (void)resetSampleBufferDelegate;
/** 取消根据光线强弱值打开手电筒的 delegate 方法 */
- (void)cancelSampleBufferDelegate;

@end

