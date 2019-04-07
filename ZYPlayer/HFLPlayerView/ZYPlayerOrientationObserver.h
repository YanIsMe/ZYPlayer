//
//  HFPlayerOrientationObserver.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/10.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPlayerOrientationObserver : NSObject

@property (nonatomic, strong) UIView *fullScreenContainerView;

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen;

/// default is 0.30
@property (nonatomic) float duration;

@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

/// default is YES.
@property (nonatomic) BOOL allowOrentitaionRotation;

/// default is UIInterfaceOrientationMaskAllButUpsideDown
@property (nonatomic, assign) UIInterfaceOrientationMask supportInterfaceOrientation;

@property (nonatomic, copy, nullable) void(^orientationWillChange)(ZYPlayerOrientationObserver *observer, BOOL isFullScreen);

@property (nonatomic, copy, nullable) void(^orientationDidChanged)(ZYPlayerOrientationObserver *observer, BOOL isFullScreen);

- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView;

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

- (void)addDeviceOrientationObserver;
- (void)removeDeviceOrientationObserver;

@end
