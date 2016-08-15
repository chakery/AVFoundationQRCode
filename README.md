# AVFoundationQRCode
使用AVFoundation实现二维码、条形码扫描

###How to use ?

```objective-c
#import "QRCodeViewController.h"

@interface ViewController ()<QRCodeDelegate>
@end
```

```objective-c
QRCodeViewController *qrCode = [[QRCodeViewController alloc]init];
qrCode.delegate = self;
[self presentViewController:qrCode animated:YES completion:nil];
```

```objective-c
-(void)QRCodeResult:(NSString *)string{
  NSLog(@"%@", string);
}
```
