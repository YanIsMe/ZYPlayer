//
//  HFPlayerVolumeBrightnessManager.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/12.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerVolumeBrightnessManager.h"
#import "ZYPlayerUtilities.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ZYPlayerBrightnessView ()

@property (nonatomic, strong) UIImageView        *backImage;
@property (nonatomic, strong) UILabel            *title;
@property (nonatomic, strong) UIView            *longView;
@property (nonatomic, strong) NSMutableArray    *tipArray;

@end

@implementation ZYPlayerBrightnessView

- (instancetype)init
{
    if (self = [super init]) {
        CGFloat width = 155;
        self.frame = CGRectMake((HFPlayerScreenWidth - width)* 0.5, (HFPlayerScreenHeight- width) * 0.5, width, width);
        
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        
        // 使用UIToolbar实现毛玻璃效果，简单粗暴，支持iOS7+
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.alpha = 0.97;
        [self addSubview:toolbar];
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 76)];
        self.backImage.image        = HFPlayerImage(@"ZFPlayer_brightness");
        [self addSubview:self.backImage];
        
        self.title      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        self.title.font          = [UIFont boldSystemFontOfSize:16];
        self.title.textColor     = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.text          = @"亮度";
        [self addSubview:self.title];
        
        self.longView         = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        self.longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:self.longView];
        
        [self createTips];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);
    self.center = CGPointMake(HFPlayerScreenWidth * 0.5, HFPlayerScreenHeight * 0.5);
}

- (void)createTips
{
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX          = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}

#pragma mark - Update View

- (void)updateLongView:(CGFloat)sound
{
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

@end

@interface ZYPlayerVolumeBrightnessManager ()

@property (nonatomic, strong) ZYPlayerBrightnessView *brightnessView;
@property (nonatomic, strong) UISlider *volumeViewSlider;

@end

@implementation ZYPlayerVolumeBrightnessManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureVolume];
    }
    return self;
}

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(ZYPlayerVolumeBrightnessType)volumeBrightnessType
{
    if (volumeBrightnessType == ZYPlayerVolumeBrightnessTypeVolume) {
        self.volumeViewSlider.value = progress;
    } else if (volumeBrightnessType == ZYPlayerVolumeBrightnessTypeumeBrightness) {
        CGFloat width = 155;
        self.brightnessView.frame = CGRectMake((HFPlayerScreenWidth - width)* 0.5, (HFPlayerScreenHeight- width) * 0.5, width, width);
        [self.brightnessView updateLongView:[UIScreen mainScreen].brightness];
        [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.brightnessView];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBrightnessView) object:nil];
        [self performSelector:@selector(hideBrightnessView) withObject:nil afterDelay:2.0];
    }
}

- (void)updateLayout
{
    if (self.brightnessView.superview == nil) return;
    CGFloat width = 155;
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown || currentOrientation == UIInterfaceOrientationUnknown) {
        currentOrientation = UIInterfaceOrientationPortrait;
    }
    if (currentOrientation == UIDeviceOrientationPortrait) {
        self.brightnessView.frame = CGRectMake((HFPlayerScreenWidth - width)* 0.5, (HFPlayerScreenHeight - width) * 0.5, width, width);
    } else {
        self.brightnessView.frame = CGRectMake((HFPlayerScreenHeight - width)* 0.5, (HFPlayerScreenWidth - width) * 0.5, width, width);
    }
    self.brightnessView.transform = [ZYPlayerUtilities getTransformRotationAngle:currentOrientation];
}

- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // Apps using this category don't mute when the phone's mute button is turned on, but play sound when the phone is silent
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];//蓝牙问题
  //  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)hideBrightnessView
{
    [UIView animateWithDuration:0.35 animations:^{
        self.brightnessView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.brightnessView removeFromSuperview];
        self.brightnessView.alpha = 1;
    }];
}

- (void)setBrightness:(float)brightness
{
    [UIScreen mainScreen].brightness = MIN(MAX(0, brightness), 1);
    [self.brightnessView updateLongView:[UIScreen mainScreen].brightness];
    [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
    [self updateLayout];
   // [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.brightnessView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBrightnessView) object:nil];
    [self performSelector:@selector(hideBrightnessView) withObject:nil afterDelay:2.0];
}

- (void)setVolume:(float)volume
{
    self.volumeViewSlider.value = MIN(MAX(0, volume), 1);
}

- (float)brightness
{
    return [UIScreen mainScreen].brightness;
}

- (float)volume
{
    CGFloat volume = self.volumeViewSlider.value;
    if (volume == 0) {
        volume = [[AVAudioSession sharedInstance] outputVolume];
    }
    return volume;
}

- (ZYPlayerBrightnessView *)brightnessView
{
    if (!_brightnessView) {
        _brightnessView = [[ZYPlayerBrightnessView alloc] init];
    }
    return _brightnessView;
}

@end
