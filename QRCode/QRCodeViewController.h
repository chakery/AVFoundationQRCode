//
//  QRCodeViewController.h
//  AVFoundationQRCode
//
//  Created by Chakery on 15/10/21.
//  Copyright (c) 2015年 Chakery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeDelegate <NSObject>
-(void)QRCodeResult:(NSString *)string;
@end

@interface QRCodeViewController : UIViewController
@property (nonatomic, assign) id<QRCodeDelegate> delegate;

@end
