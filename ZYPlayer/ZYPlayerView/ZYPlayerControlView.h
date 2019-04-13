//
//  HFPlayerControlView.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayerGestureControl.h"
#import "ZYPlayerManager.h"

@class ZYPlayerControlView;
@protocol ZYPlayerControlViewDelegate <NSObject>

@optional

- (void)controlViewBackAction;
- (void)controlViewFailAction;
- (void)controlViewShareAction;
- (void)controlView:(ZYPlayerControlView *)controlView playerPlayBtnState:(BOOL)state;
- (void)controlView:(ZYPlayerControlView *)controlView draggedVideoTime:(NSTimeInterval)draggedTime;
- (void)controlView:(ZYPlayerControlView *)controlView fullScreen:(BOOL)fullScreen;
- (NSTimeInterval)currentPlayTimeWithControlView:(ZYPlayerControlView *)controlView;
- (void)controlView:(ZYPlayerControlView *)controlView hideUpDownControlView:(BOOL)hide;

- (BOOL)shouldResponseGestureWithGestureType:(ZFPlayerGestureType)type touch:(UITouch *)touch;

@end

@interface ZYPlayerControlView : UIView

@property (nonatomic, weak) id<ZYPlayerControlViewDelegate> delegate;
@property (nonatomic, strong, readonly) ZFPlayerGestureControl *gestureControl;
@property (nonatomic, assign) BOOL fullScreen;

- (void)setVideoBufferProgress:(float)bufferProgress bufferTime:(NSTimeInterval)bufferTime totalTime:(NSTimeInterval)totalTime;
- (void)setVideoCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
- (void)playStateChanged:(HFPlayerPlayState)state;
- (void)playerPlayBtnState:(BOOL)state;
- (void)resetControlView;

@end
