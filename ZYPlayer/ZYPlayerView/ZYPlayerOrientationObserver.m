//
//  HFPlayerOrientationObserver.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/10.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerOrientationObserver.h"

@interface UIWindow (CurrentViewController)

/*!
 @method currentViewController
 @return Returns the topViewController in stack of topMostController.
 */
+ (UIViewController*)zy_currentViewController;

@end

@implementation UIWindow (CurrentViewController)

+ (UIViewController*)zy_currentViewController;
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end

@interface ZYPlayerOrientationObserver ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, strong) UIView *blackView;

@end

@implementation ZYPlayerOrientationObserver

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.35;
        _supportInterfaceOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
        _allowOrentitaionRotation = YES;
    }
    return self;
}

- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView
{
    self.view = rotateView;
    self.containerView = containerView;
}

- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange
{
    if (!self.allowOrentitaionRotation) return;
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (_currentOrientation == currentOrientation) return;//&& ![self isNeedAdaptiveiOS8Rotation]
    switch (_currentOrientation) {
        case UIInterfaceOrientationPortrait: {
//            if ([self isSupportedPortrait]) {
//                [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait animated:YES];
//            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            if ([self isSupportedLandscapeLeft]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            if ([self isSupportedLandscapeRight]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
            }
        }
            break;
        default: {
            if ([self isSupportedLandscapeRight]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
            }
        }
            
            break;
    }
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated
{
    _currentOrientation = orientation;
    UIView *superview = nil;
    CGRect frame;
//    if (UIInterfaceOrientationIsLandscape(orientation)) { //暂时不处理竖屏返回问题
        superview = self.fullScreenContainerView;
        if (!self.isFullScreen) { /// It's not set from the other side of the screen to this side
            self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        }
        self.fullScreen = YES;
        /// 先加到window上，效果更好一些
        [superview addSubview:_view];
//    } else {
//        if (self.roateType == ZFRotateTypeCell) superview = [self.cell viewWithTag:self.playerViewTag];
//        else
//        superview = self.containerView;
//        self.fullScreen = NO;
//        if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
//    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [UIApplication sharedApplication].statusBarOrientation = orientation;
#pragma clang diagnostic pop
    
    frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.transform = [self getTransformRotationAngle:orientation];
            //[UIView animateWithDuration:self.duration animations:^{
                self.view.frame = frame;
                [self.view layoutIfNeeded];
            //}];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.fullScreen) {
                [superview insertSubview:self.blackView belowSubview:self.view];
                self.blackView.frame = superview.bounds;
            }
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        self.view.transform = [self getTransformRotationAngle:orientation];
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.fullScreen) {
            [superview insertSubview:self.blackView belowSubview:self.view];
            self.blackView.frame = superview.bounds;
        }
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated
{
    if (fullScreen) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
        [self addDeviceOrientationObserver];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:{
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
            }
                break;
            default:
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];;
                break;
        }
    } else {
        [self removeDeviceOrientationObserver];
        if (self.fullScreen == fullScreen) return;
        UIView *superview = self.containerView;
        if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
        self.fullScreen = NO;
        CGRect frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        if (animated) {
            if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
            [UIView animateWithDuration:self.duration animations:^{
                self.view.transform = [self getTransformRotationAngle:UIInterfaceOrientationPortrait];
                //[UIView animateWithDuration:self.duration animations:^{
                    self.view.frame = frame;
                    [self.view layoutIfNeeded];
               // }];
            } completion:^(BOOL finished) {
                [superview addSubview:self.view];
                self.view.frame = superview.bounds;
                if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
            }];
        } else {
            self.view.frame = frame;
            [self.view layoutIfNeeded];
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }
    }
}

/// Gets the rotation Angle of the transformation.
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

/// 是否支持 Portrait
- (BOOL)isSupportedPortrait {
    return self.supportInterfaceOrientation & UIInterfaceOrientationMaskPortrait;
}

/// 是否支持 LandscapeLeft
- (BOOL)isSupportedLandscapeLeft {
    return self.supportInterfaceOrientation & UIInterfaceOrientationMaskLandscapeLeft;
}

/// 是否支持 LandscapeRight
- (BOOL)isSupportedLandscapeRight {
    return self.supportInterfaceOrientation & UIInterfaceOrientationMaskLandscapeRight;
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [UIView new];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

#pragma mark - setter

- (UIView *)fullScreenContainerView
{
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    [[UIWindow zy_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    [[UIWindow zy_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

@end
