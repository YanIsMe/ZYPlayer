//
//  HFPlayerFastView.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerFastView.h"
#import "ZYPlayerSliderView.h"
#import "ZYPlayerUtilities.h"

@interface ZYPlayerFastView ()

/// 快进快退进度progress
@property (nonatomic, strong) ZYPlayerSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong) UIImageView *fastImageView;

@end

@implementation ZYPlayerFastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.fastImageView];
        [self addSubview:self.fastTimeLabel];
        [self addSubview:self.fastProgressView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    self.fastImageView.frame = CGRectMake((self.width - 32) / 2, 5, 32, 32);
    self.fastTimeLabel.frame = CGRectMake(0, self.fastImageView.bottom + 2, self.width, 20);
    self.fastProgressView.frame = CGRectMake(12, self.fastTimeLabel.bottom + 5, self.width - 2 * 10, 10);
}

- (void)setTimeText:(NSString *)timeText
{
    _timeText = timeText;
    self.fastTimeLabel.text = timeText;
}

- (void)setForward:(BOOL)forward
{
    _forward = forward;
    if (forward) {
        self.fastImageView.image = HFPlayerImage(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = HFPlayerImage(@"ZFPlayer_fast_backward");
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    self.fastProgressView.value = progress;
}

- (ZYPlayerSliderView *)fastProgressView
{
    if (!_fastProgressView) {
        _fastProgressView = [[ZYPlayerSliderView alloc] init];
        _fastProgressView.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        _fastProgressView.minimumTrackTintColor = [UIColor whiteColor];
        _fastProgressView.sliderHeight = 2;
        _fastProgressView.isHideSliderBlock = NO;
    }
    return _fastProgressView;
}

- (UIImageView *)fastImageView
{
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel
{
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _fastTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fastTimeLabel;
}

@end
