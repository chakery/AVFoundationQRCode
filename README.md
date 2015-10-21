# AVFoundationQRCode
使用AVFoundation实现二维码、条形码扫描

###How to use ?
* 1 
```objective-c
#import "QRCodeViewController.h"

@interface ViewController ()<QRCodeDelegate>
@end
```
* 2
```objective-c
QRCodeViewController *qrCode = [[QRCodeViewController alloc]init];
qrCode.delegate = self;
[self presentViewController:qrCode animated:YES completion:nil];
```
* 3
```objective-c
-(void)QRCodeResult:(NSString *)string{
  NSLog(@"%@", string);
}
```
