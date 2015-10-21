//
//  QRCodeViewController.m
//  AVFoundationQRCode
//
//  Created by Chakery on 15/10/21.
//  Copyright (c) 2015年 Chakery. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIView *borderView;//边框
@property (nonatomic, strong) UIView *lineView;//横线
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) UIButton *lightButton;//灯
@property (nonatomic, strong) UIButton *cancelButton;//灯
@end

@implementation QRCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    [self setupCamera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  设置二维码扫描
 */
- (void)setupCamera {
    // 初始化摄像头
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 输入流
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        [[[UIAlertView alloc]initWithTitle:@"警告" message:@"摄像头打开失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    // 输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 实例化会话
    _session = [[AVCaptureSession alloc]init];
    
    // 高质量采取率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 添加输入流
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    // 添加输出流
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 扫码类型
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode //二维码
                                    ,AVMetadataObjectTypeCode128Code //CODE128条码  顺丰
                                    ,AVMetadataObjectTypeEAN8Code
                                    ,AVMetadataObjectTypeUPCECode
                                    ,AVMetadataObjectTypeCode39Code //条形码 韵达 申通
                                    ,AVMetadataObjectTypePDF417Code
                                    ,AVMetadataObjectTypeAztecCode
                                    ,AVMetadataObjectTypeCode93Code //星号表示起始符及终止符的条形码 EMS
                                    ,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];

    // 预览
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CGRectMake((WIDTH - 300)/2,100,300,300);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // 开始
    [_session startRunning];
}

/**
 *  protocol method
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    // 停止横线
    [_timer invalidate];
    
    // 返回结果
    [_delegate QRCodeResult:stringValue];
    
    // 停止扫描、返回上一页
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置ui
 */
-(void)setUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    // 边框
    _borderView = [[UIView alloc]init];
    _borderView.frame = CGRectMake((WIDTH - 300)/2, 100, 300, 300);
    _borderView.layer.borderColor = [[UIColor greenColor]CGColor];
    _borderView.layer.borderWidth = 2;
    _borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_borderView];
    
    // 横线
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(0, 0, _borderView.bounds.size.width, 1);
    _lineView.backgroundColor = [UIColor greenColor];
    [_borderView addSubview:_lineView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeLineDirection) userInfo:nil repeats:YES];
    
    // 开灯
    _lightButton = [[UIButton alloc]init];
    _lightButton.tag = 101;
    _lightButton.frame = CGRectMake(10, HEIGHT - 60, 100, 50);
    _lightButton.backgroundColor = [UIColor whiteColor];
    [_lightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lightButton setTitle:@"开灯" forState:UIControlStateNormal];
    [_lightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:_lightButton];
    
    // 取消
    _cancelButton = [[UIButton alloc]init];
    _cancelButton.tag = 102;
    _cancelButton.frame = CGRectMake(WIDTH - 110, HEIGHT - 60, 100, 50);
    _cancelButton.backgroundColor = [UIColor whiteColor];
    [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:_cancelButton];
}

/**
 *  改变横线的位置
 */
-(void)changeLineDirection{
    CGRect frame = _lineView.frame;
    frame.origin.y ++;
    if (_lineView.frame.origin.y == _borderView.frame.size.height) {
        frame.origin.y = 0;
    }
    _lineView.frame = frame;
}

/**
 *  按钮点击事件
 *
 *  @param button
 */
-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 101:
        {
            [self lightManager];
        }
            break;
            
        case 102:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  开关灯
 */
-(void)lightManager{
    // 开灯
    if(_device.torchMode != AVCaptureTorchModeOn ||
       _device.flashMode != AVCaptureFlashModeOn){
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device setFlashMode:AVCaptureFlashModeOn];
        [_device unlockForConfiguration];
        
        // 关灯
    } else if(_device.torchMode != AVCaptureTorchModeOff ||
              _device.flashMode != AVCaptureFlashModeOff){
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device setFlashMode:AVCaptureFlashModeOff];
        [_device unlockForConfiguration];
    }
}

@end
