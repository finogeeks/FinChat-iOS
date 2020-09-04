//
//  FCQRCodeScanningViewController.m
//  FCoConversation
//
//  Created by 杨涛 on 2017/12/31.
//  Copyright © 2017年 杨涛. All rights reserved.
//

#import "FCQRCodeScanningViewController.h"
#import "FCQRCodeScanManager.h"
#import "FCQRCode.h"
#import "FCQRCodeErrorViewController.h"

@interface FCQRCodeScanningViewController () <FCQRCodeScanManagerDelegate,FCQRCodeAlbumManagerDelegate>
{
    // Appearance
    BOOL _previousNavBarHidden;
    BOOL _previousNavBarTranslucent;
    UIBarStyle _previousNavBarStyle;
    UIStatusBarStyle _previousStatusBarStyle;
    UIColor *_previousNavBarTintColor;
    UIColor *_previousNavBarBarTintColor;
    UIBarButtonItem *_previousViewControllerBackButton;
    UIImage *_previousNavigationBarBackgroundImageDefault;
    UIImage *_previousNavigationBarBackgroundImageLandscapePhone;
    BOOL _didSavePreviousStateOfNavBar;
    NSDictionary *_previousNavBarTitleAttributes;
}
@property (nonatomic, strong) FCQRCodeScanManager *manager;
@property (nonatomic, strong) FCQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FCQRCodeScanningViewController

#pragma mark - circle life method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
//    [self p_setupNavigationBar];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                [self fin_showAlert:@"无法访问您的相机" message:@"请到设置 -> 隐私 -> 相机 ，打开访问权限" completion:nil];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setupQRCodeScanning];
                });
            }
        }];
    });
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    [self p_storePreviousNavBarAppearance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_handleNavBar];
    
    [_manager startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    [self removeScanningView];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [self restorePreviousNavBarAppearance:YES];
    [super willMoveToParentViewController:parent];
}

#pragma mark - private tool method

- (void)fin_showAlert:(NSString*)title message:(NSString*)message completion:(void (^)(void))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completion)
            completion();
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)p_storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    _previousNavBarTitleAttributes = self.navigationController.navigationBar.titleTextAttributes;
    _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        [UIApplication sharedApplication].statusBarStyle = _previousStatusBarStyle;
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        navBar.barTintColor = _previousNavBarBarTintColor;
        navBar.barStyle = _previousNavBarStyle;
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsLandscapePhone];
        // Restore back button if we need to
        if (_previousViewControllerBackButton) {
            UIViewController *previousViewController = [self.navigationController topViewController]; // We've disappeared so previous is now top
            previousViewController.navigationItem.backBarButtonItem = _previousViewControllerBackButton;
            _previousViewControllerBackButton = nil;
        }
        if (!_previousNavBarTitleAttributes) {
            navBar.titleTextAttributes = nil;
        } else {
            navBar.titleTextAttributes = _previousNavBarTitleAttributes;
        }
    }
}

//- (void)p_setupNavigationBar {
//    self.navigationItem.title = @"扫一扫";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
//}

- (void)p_handleNavBar {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FCQRCodeHelperTool FC_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

- (void)setupQRCodeScanning {
    self.manager = [FCQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    //    [manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - click events
//- (void)rightBarButtonItenAction {
//    FCQRCodeAlbumManager *manager = [FCQRCodeAlbumManager sharedManager];
//    [manager readQRCodeFromAlbumWithCurrentController:self];
//    manager.delegate = self;
//
//    if (manager.isPHAuthorization == YES) {
//        [self.scanningView removeTimer];
//    }
//}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [FCQRCodeHelperTool FC_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

#pragma mark -  FCQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(FCQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(FCQRCodeAlbumManager *)albumManager didFCishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        
    }
    else{
        FCQRCodeErrorViewController *qrCodeVC = [FCQRCodeErrorViewController new];
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }
}

#pragma mark -  FCQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(FCQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    if (metadataObjects != nil && metadataObjects.count > 0) {
        //        [scanManager palySoundName:@"FCQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSLog(@"%@",[obj stringValue]);
        [self.delegate setQRResult:[obj stringValue]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        FCQRCodeErrorViewController *qrCodeVC = [FCQRCodeErrorViewController new];
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }
}
- (void)QRCodeScanManager:(FCQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

#pragma mark - getter & setter
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark  闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"FCQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"FCQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}


- (FCQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[FCQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
        //        _scanningView.scanningImageName = @"FCQRCode.bundle/QRCodeScanningLineGrid";
        //        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        //        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}

@end

