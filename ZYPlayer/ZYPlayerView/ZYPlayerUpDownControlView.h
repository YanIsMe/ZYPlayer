//
//  HFPlayerUpDownControlView.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/8.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYPlayerUpDownControlViewDelegate <NSObject>

@optional

- (void)upDownSliderValueChanged:(float)value;
- (void)upDownSliderTouchEnded:(float)value;
- (void)upDownPlayOrPause:(BOOL)play;
- (void)upDownFullScreen:(BOOL)fullScreen;
- (void)upDownBackAction;
- (void)upDownShareAction;

@end

@interface ZYPlayerUpDownControlView : UIView

@property (nonatomic, weak) id<ZYPlayerUpDownControlViewDelegate> delegate;
@property (nonatomic, assign) BOOL fullScreen;

- (void)showUpDownControlView;
- (void)hideUpDownControlView;
- (void)resetUpDownControlView;
/// 根据当前播放状态取反
- (void)playOrPause;
- (void)playBtnSelectedState:(BOOL)selected;

- (void)videoPlayCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
- (void)setBufferProgress:(float)bufferProgress;

@end
