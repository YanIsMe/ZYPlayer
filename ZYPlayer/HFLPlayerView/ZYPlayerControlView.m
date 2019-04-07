//
//  HFPlayerControlView.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerControlView.h"
#import "ZYPlayerSliderView.h"
#import "ZYPlayerLoadingView.h"
#import "ZYPlayerUtilities.h"
#import "ZYPlayerFastView.h"
#import "ZYPlayerUpDownControlView.h"
#import "ZYPlayerVolumeBrightnessManager.h"

@interface ZYPlayerControlView ()<ZYPlayerUpDownControlViewDelegate>

@property (nonatomic, strong) ZYPlayerLoadingView *activity;
@property (nonatomic, strong) ZYPlayerFastView *fastView;
@property (nonatomic, strong) ZYPlayerUpDownControlView *upDownView;
@property (nonatomic, strong) ZYPlayerSliderView *bottomPgrogress;
@property (nonatomic, strong) UIButton *failBtn;

@property (nonatomic, assign) BOOL controlViewAppeared;
@property (nonatomic, strong) dispatch_block_t afterBlock;
@property (nonatomic, strong) ZFPlayerGestureControl *gestureControl;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, assign) NSTimeInterval sumTime;

@property (nonatomic, strong) ZYPlayerVolumeBrightnessManager *volumeBrightnessManager;

@end

@implementation ZYPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.upDownView];
        
        [self addSubview:self.activity];
        [self addSubview:self.failBtn];
        [self addSubview:self.fastView];
        [self addSubview:self.bottomPgrogress];
        
        self.totalTime = 0;
        self.sumTime = 0;
    }
    return self;
}

- (void)dealloc
{
    [self cancelAutoFadeOutControlView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.activity.frame = CGRectMake(self.width/2 - 25, self.height/2 - 25, 50, 50);
    
    self.failBtn.frame = CGRectMake(0, 0, 150, 30);
    self.failBtn.center = self.center;
    
    
    self.fastView.frame = CGRectMake(0, 0, 140, 80);
    self.fastView.center = self.center;
    
    self.upDownView.frame = self.bounds;
    
    self.bottomPgrogress.frame = CGRectMake(0, self.height - 1, self.width, 1);
    [self.volumeBrightnessManager updateLayout];
}

- (void)autoFadeOutControlView
{
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    __weak typeof(self) weakSelf = self;
    self.afterBlock = dispatch_block_create(0, ^{
        [weakSelf hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView
{
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?0.25f:0 animations:^{
        [self.upDownView hideUpDownControlView];
        self.controlViewAppeared = NO;
        if ([self.delegate respondsToSelector:@selector(controlView:hideUpDownControlView:)]) {
            [self.delegate controlView:self hideUpDownControlView:YES];
        }
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = NO;
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated
{
    [self cancelAutoFadeOutControlView];
    [UIView animateWithDuration:animated?0.25f:0 animations:^{
        [self.upDownView showUpDownControlView];
        self.bottomPgrogress.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(controlView:hideUpDownControlView:)]) {
            [self.delegate controlView:self hideUpDownControlView:NO];
        }
    } completion:^(BOOL finished) {
        [self autoFadeOutControlView];
    }];
}

- (void)setVideoBufferProgress:(float)bufferProgress bufferTime:(NSTimeInterval)bufferTime totalTime:(NSTimeInterval)totalTime
{
    self.totalTime = totalTime;
    [self.upDownView setBufferProgress:bufferProgress];
}

- (void)setVideoCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    self.totalTime = totalTime;
    [self.upDownView videoPlayCurrentTime:currentTime totalTime:totalTime];
    if (totalTime > 0) {
        self.bottomPgrogress.value = currentTime/totalTime;
    } else self.bottomPgrogress.value = 0;
}

- (void)playStateChanged:(HFPlayerPlayState)state
{
    if (state == HFPlayerPlayStateBuffering) {
        [self.activity startAnimating];
    } else [self.activity stopAnimating];
    if (state == HFPlayerPlayStatePlaying) {
        //[self.upDownView playBtnSelectedState:YES];
    } else if (state == HFPlayerPlayStateFailed) {
        self.failBtn.hidden = NO;
    } else {}
}

- (void)playerPlayBtnState:(BOOL)state
{
    [self.upDownView playBtnSelectedState:state];
}

- (void)resetControlView;
{
    self.hidden = NO;
    [self.upDownView resetUpDownControlView];
    self.failBtn.hidden = YES;
    self.bottomPgrogress.value = 0;
    if (self.controlViewAppeared) {
        [self hideControlViewWithAnimated:NO];
    } else {
        [self showControlViewWithAnimated:NO];
    }
}

#pragma mark - ZYPlayerUpDownControlViewDelegate

- (void)upDownSliderValueChanged:(float)value
{
    [self cancelAutoFadeOutControlView];
}

- (void)upDownSliderTouchEnded:(float)value
{
    if ([self.delegate respondsToSelector:@selector(controlView:draggedVideoTime:)]) {
        [self.delegate controlView:self draggedVideoTime:self.totalTime*value];
    }
    [self autoFadeOutControlView];
}

- (void)upDownPlayOrPause:(BOOL)play
{
    if ([self.delegate respondsToSelector:@selector(controlView:playerPlayBtnState:)]) {
        [self.delegate controlView:self playerPlayBtnState:play];
    }
}

- (void)upDownFullScreen:(BOOL)fullScreen
{
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:fullScreen];
    }
}

- (void)upDownBackAction
{
    if ([self.delegate respondsToSelector:@selector(controlViewBackAction)]) {
        [self.delegate controlViewBackAction];
    }
}

- (void)upDownShareAction{
    if ([self.delegate respondsToSelector:@selector(controlViewShareAction)]) {
        [self.delegate controlViewShareAction];
    }
}

#pragma mark - 手势处理

/// 手势筛选，返回NO不响应该手势
- (BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch
{
    if (self.hidden) return NO;
    if (gestureType == ZFPlayerGestureTypePinch) return NO;
    if ([self.delegate respondsToSelector:@selector(shouldResponseGestureWithGestureType:touch:)]) {
        return [self.delegate shouldResponseGestureWithGestureType:gestureType touch:touch];
    }
    return YES;
}

/// 单击手势事件
- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl
{
    if (self.controlViewAppeared) {
        [self hideControlViewWithAnimated:YES];
    } else {
        [self showControlViewWithAnimated:YES];
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl
{
    [self.upDownView playOrPause];
}

/// 开始滑动手势事件
- (void)gestureBeganPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location
{
    if (direction == ZFPanDirectionH) {
        if ([self.delegate respondsToSelector:@selector(currentPlayTimeWithControlView:)]) {
            self.sumTime = [self.delegate currentPlayTimeWithControlView:self];
        }
    }
}

/// 滑动中手势事件
- (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity
{
    if (direction == ZFPanDirectionH) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 200;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
        if (self.sumTime < 0) { self.sumTime = 0; }
        BOOL style = false;
        if (velocity.x > 0) { style = YES; }
        if (velocity.x < 0) { style = NO; }
        if (velocity.x == 0) { return; }
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
    } else if (direction == ZFPanDirectionV) {
        if (location == ZFPanLocationLeft) { /// 调节亮度
            self.volumeBrightnessManager.brightness -= (velocity.y) / 10000;
        } else if (location == ZFPanLocationRight) { /// 调节声音
            self.volumeBrightnessManager.volume -= (velocity.y) / 10000;
        }
    }
}

/// 滑动结束手势事件
- (void)gestureEndedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location
{
    if (direction == ZFPanDirectionH && self.sumTime >= 0 && self.totalTime > 0) {
        if ([self.delegate respondsToSelector:@selector(controlView:draggedVideoTime:)]) {
            [self.delegate controlView:self draggedVideoTime:self.sumTime];
        }
        self.sumTime = 0;
    }
}

#pragma mark - Private Method

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward
{
    self.fastView.progress = value;
    self.fastView.hidden = NO;
    self.fastView.alpha = 1;
    self.fastView.forward = forward;
    NSString *draggedTime = [ZYPlayerUtilities convertTimeSecond:self.totalTime*value];
    NSString *totalTime = [ZYPlayerUtilities convertTimeSecond:self.totalTime];
    self.fastView.timeText = [NSString stringWithFormat:@"%@ / %@",draggedTime,totalTime];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.1];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformMakeTranslation(forward?10:-10, 0);
    }];
}

/// 隐藏快进视图
- (void)hideFastView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
        self.fastView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}

- (void)failBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(controlViewFailAction)]) {
        [self.delegate controlViewFailAction];
    }
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    self.upDownView.fullScreen = fullScreen;
}

#pragma mark - getter

- (ZYPlayerLoadingView *)activity
{
    if (!_activity) {
        _activity = [[ZYPlayerLoadingView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activity.lineWidth = 0.8;
        _activity.duration = 1;
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (ZYPlayerFastView *)fastView
{
    if (!_fastView) {
        _fastView = [[ZYPlayerFastView alloc] initWithFrame:CGRectZero];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _fastView.layer.cornerRadius = 4;
        _fastView.layer.masksToBounds = YES;
        _fastView.hidden = YES;
        _fastView.forward = YES;
        _fastView.timeText = @"00:00/00:00";
    }
    return _fastView;
}

- (ZYPlayerUpDownControlView *)upDownView
{
    if (!_upDownView) {
        _upDownView = [[ZYPlayerUpDownControlView alloc] initWithFrame:CGRectZero];
        _upDownView.delegate = self;
    }
    return _upDownView;
}

- (ZYPlayerSliderView *)bottomPgrogress
{
    if (!_bottomPgrogress) {
        _bottomPgrogress = [[ZYPlayerSliderView alloc] init];
        _bottomPgrogress.maximumTrackTintColor = [UIColor clearColor];
        _bottomPgrogress.minimumTrackTintColor = [UIColor whiteColor];
        _bottomPgrogress.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _bottomPgrogress.sliderHeight = 1;
        _bottomPgrogress.isHideSliderBlock = NO;
        _bottomPgrogress.value = 0;
    }
    return _bottomPgrogress;
}

- (ZFPlayerGestureControl *)gestureControl
{
    if (!_gestureControl) {
        ZFPlayerGestureControl *gestureControl = [[ZFPlayerGestureControl alloc] init];
        __weak typeof(self) weakSelf = self;
        gestureControl.triggerCondition = ^BOOL(ZFPlayerGestureControl * _Nonnull control, ZFPlayerGestureType type, UIGestureRecognizer * _Nonnull gesture, UITouch *touch) {
                return [weakSelf gestureTriggerCondition:control gestureType:type gestureRecognizer:gesture touch:touch];
        };
        
        gestureControl.singleTapped = ^(ZFPlayerGestureControl * _Nonnull control) {
                [weakSelf gestureSingleTapped:control];
        };
        
        gestureControl.doubleTapped = ^(ZFPlayerGestureControl * _Nonnull control) {
                [weakSelf gestureDoubleTapped:control];
        };
        
        gestureControl.beganPan = ^(ZFPlayerGestureControl * _Nonnull control, ZFPanDirection direction, ZFPanLocation location) {
                [weakSelf gestureBeganPan:control panDirection:direction panLocation:location];
        };
        
        gestureControl.changedPan = ^(ZFPlayerGestureControl * _Nonnull control, ZFPanDirection direction, ZFPanLocation location, CGPoint velocity) {
                [weakSelf gestureChangedPan:control panDirection:direction panLocation:location withVelocity:velocity];
        };
        
        gestureControl.endedPan = ^(ZFPlayerGestureControl * _Nonnull control, ZFPanDirection direction, ZFPanLocation location) {
                [weakSelf gestureEndedPan:control panDirection:direction panLocation:location];
        };
        
//        gestureControl.pinched = ^(ZFPlayerGestureControl * _Nonnull control, float scale) {//捏合
//                [weakSelf gesturePinched:control scale:scale];
//        };
        _gestureControl = gestureControl;
    }
    return _gestureControl;
}

- (UIButton *)failBtn
{
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _failBtn.hidden = YES;
    }
    return _failBtn;
}

- (ZYPlayerVolumeBrightnessManager *)volumeBrightnessManager
{
    if (!_volumeBrightnessManager) {
        _volumeBrightnessManager = [[ZYPlayerVolumeBrightnessManager alloc] init];
    }
    return _volumeBrightnessManager;
}

@end
