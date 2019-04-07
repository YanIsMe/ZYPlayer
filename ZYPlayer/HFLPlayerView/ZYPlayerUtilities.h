//
//  HFPlayerUtilities.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+ZYFrame.h"

static inline BOOL ZYIsIPhoneX() {
    BOOL isIPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return isIPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            
            isIPhoneX = YES;
        }
    }
    return isIPhoneX;
}
//iPhoneX适配
#define HFPlayerIPhoneX ZYIsIPhoneX()
static UIEdgeInsets const IPhoneXSafeAreaPotrait = {44, 0, 34, 0};
static UIEdgeInsets const IPhoneXSafeAreaLanscape = {0, 44, 21, 44};

// 图片路径
#define HFPlayerSrcName(file)               [@"HFPlayer.bundle" stringByAppendingPathComponent:file]
#define HFPlayerImage(file)                 [UIImage imageNamed:HFPlayerSrcName(file)]

// 屏幕的宽和高
#define HFPlayerScreenWidth                 [[UIScreen mainScreen] bounds].size.width
#define HFPlayerScreenHeight                [[UIScreen mainScreen] bounds].size.height

@interface ZYPlayerUtilities : NSObject

+ (NSString *)convertTimeSecond:(NSInteger)timeSecond;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIViewController*)zy_currentViewController;
+ (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation;

@end
