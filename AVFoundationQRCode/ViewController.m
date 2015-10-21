//
//  ViewController.m
//  AVFoundationQRCode
//
//  Created by Chakery on 15/10/21.
//  Copyright (c) 2015年 Chakery. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeViewController.h"

@interface ViewController ()<QRCodeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     
     1. 把QRCode文件夹拖拽到Xcode工程
     2. 引入头文件 #import "QRCodeViewController.h"
     3. 实现代理 <QRCodeDelegate>
     4. 创建 QRCodeViewController 对象
     5. 跳转到扫描界面
     6. 实现协议方法 -(void)QRCodeResult:(NSString *)string
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)scanEvent:(id)sender {
    QRCodeViewController *qrCode = [[QRCodeViewController alloc]init];
    qrCode.delegate = self;
    [self presentViewController:qrCode animated:YES completion:nil];
}

/**
 *  扫码成功后返回的结果
 *
 *  @param string 返回的结果字符串
 */
-(void)QRCodeResult:(NSString *)string{
    NSLog(@"%@", string);
}

@end
