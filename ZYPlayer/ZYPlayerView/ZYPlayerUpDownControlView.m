//
//  HFPlayerUpDownControlView.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/8.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerUpDownControlView.h"
#import "ZYPlayerUtilities.h"
#import "ZYPlayerSliderView.h"

@interface ZYPlayerUpDownControlView ()<ZYPlayerSliderViewDelegate>
//顶部
@property (nonatomic, strong) UIImageView             *topImageView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部
@property (nonatomic, strong) UIImageView             *bottomImageView;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) ZYPlayerSliderView *slider;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) NSTimeInterval totalTime;

@end

@implementation ZYPlayerUpDownControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self.topImageView addSubview:self.backBtn];
        [self.topImageView addSubview:self.titleLabel];
//        [self.topImageView addSubview:self.shareBtn];
        
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.playOrPauseBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.slider];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        
        self.totalTime = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat H = 0;
    
    UIEdgeInsets iPhoneXSafeAreaInsets = UIEdgeInsetsZero;
    if (self.fullScreen) {
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown || currentOrientation == UIInterfaceOrientationUnknown) {
            currentOrientation = UIInterfaceOrientationPortrait;
        }
        if (currentOrientation == UIDeviceOrientationPortrait) iPhoneXSafeAreaInsets = IPhoneXSafeAreaPotrait;
        else iPhoneXSafeAreaInsets = IPhoneXSafeAreaLanscape;
    }
    
    H = HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.top + 76 :76;
    self.topImageView.frame = CGRectMake(0, 0, self.width, H);
    X = HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.left : 0;
    Y = HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.top + 20:20;
    self.backBtn.frame = CGRectMake(X, Y, 40, 40);
    
    /*
    self.shareBtn.size = CGSizeMake(40, 40);
    self.shareBtn.x    = (HFPlayerIPhoneX ? (self.width - iPhoneXSafeAreaInsets.right - self.shareBtn.width):self.width - self.shareBtn.width) - 10;
    self.shareBtn.centerY = self.backBtn.centerY;
     */
    
    self.titleLabel.frame = CGRectMake(self.backBtn.right + 5, 0, self.topImageView.width - self.backBtn.right - 5, 30);
    self.titleLabel.centerY = self.backBtn.centerY;
    
    H = HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.bottom+50: 50;
    self.bottomImageView.frame = CGRectMake(0, self.height - H, self.width, H);
    
    Y = 10;
    X = HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.left + 6: 6;
    self.playOrPauseBtn.frame = CGRectMake(X, Y, 30, 30);
    
//    if (self.fullScreen) {
//        self.fullScreenBtn.frame = CGRectMake(self.bottomImageView.width - (HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.right : 0), 0, 0, 0);
//    } else {
        X = self.bottomImageView.width - (HFPlayerIPhoneX ? iPhoneXSafeAreaInsets.right + 10: 10) - 30;
        self.fullScreenBtn.frame = CGRectMake(X, Y, 30, 30);
//    }
    
    self.currentTimeLabel.frame = CGRectMake(self.playOrPauseBtn.right + 6, Y, 30, 30);
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    X = self.fullScreenBtn.left - 10 - 30;
    self.totalTimeLabel.frame = CGRectMake(X, Y, 30, 30);
    self.totalTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    self.slider.frame = CGRectMake(self.currentTimeLabel.right + 4, Y, self.totalTimeLabel.left - self.currentTimeLabel.right - 8, 30);
    self.slider.centerY = self.playOrPauseBtn.centerY;
}

- (void)showUpDownControlView
{
    self.topImageView.alpha = 1;
    self.bottomImageView.alpha = 1;
}

- (void)hideUpDownControlView
{
    self.topImageView.alpha = 0;
    self.bottomImageView.alpha = 0;
}

- (void)playOrPause
{
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(upDownPlayOrPause:)]) {
        [self.delegate upDownPlayOrPause:self.playOrPauseBtn.selected];
    }
}

- (void)playBtnSelectedState:(BOOL)selected
{
    self.playOrPauseBtn.selected = selected;
}

- (void)videoPlayCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZYPlayerUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZYPlayerUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        if (totalTime > 0) {
            self.slider.value = currentTime/totalTime;
        } else self.slider.value = 0;
    }
    self.totalTime = totalTime;
}

- (void)setBufferProgress:(float)bufferProgress
{
    self.slider.bufferValue = bufferProgress;
}

- (void)resetUpDownControlView;
{
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
}

#pragma mark - ZYPlayerSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
//    if (self.totalTime > 0) {
//        @weakify(self)
//        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
//            @strongify(self)
//            if (finished) {
//                self.slider.isdragging = NO;
//                [self.player.currentPlayerManager play];
//            }
//        }];
//    } else {
        self.slider.isdragging = NO;
//    }
    if ([self.delegate respondsToSelector:@selector(upDownSliderTouchEnded:)]) {
        [self.delegate upDownSliderTouchEnded:value];
    }
}

- (void)sliderValueChanged:(float)value
{
    if (self.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZYPlayerUtilities convertTimeSecond:self.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if ([self.delegate respondsToSelector:@selector(upDownSliderValueChanged:)]) {
        [self.delegate upDownSliderValueChanged:value];
    }
}

- (void)sliderTapped:(float)value
{
    if (self.totalTime > 0) {
        self.slider.isdragging = YES;
        if ([self.delegate respondsToSelector:@selector(upDownSliderTouchEnded:)]) {
            [self.delegate upDownSliderTouchEnded:value];
        }
        self.slider.isdragging = NO;
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}


#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(upDownBackAction)]) {
        [self.delegate upDownBackAction];
    }
}

- (void)shareBtnClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(upDownShareAction)]) {
        [self.delegate upDownShareAction];
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender
{
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(upDownFullScreen:)]) {
        [self.delegate upDownFullScreen:!self.fullScreen];
    }
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    self.fullScreenBtn.selected = fullScreen;
    self.topImageView.hidden = !fullScreen;
}

#pragma mark - getter

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 1;
        _topImageView.image                  = HFPlayerImage(@"ZFPlayer_top_shadow");
        _topImageView.hidden                 = YES;
    }
    return _topImageView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:HFPlayerImage(@"ZFPlayer_back_jiantou") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:HFPlayerImage(@"player_share_white") forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 1;
        _bottomImageView.image                  = HFPlayerImage(@"ZFPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)playOrPauseBtn
{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:HFPlayerImage(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:HFPlayerImage(@"ZFPlayer_pause") forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (ZYPlayerSliderView *)slider
{
    if (!_slider) {
        _slider = [[ZYPlayerSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5/1.0];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1/1.0];
        _slider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:91/255.0 blue:91/255.0 alpha:1/1.0];
        [_slider setThumbImage:HFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 3;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:HFPlayerImage(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:HFPlayerImage(@"player_shrinkscreen") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

@end
