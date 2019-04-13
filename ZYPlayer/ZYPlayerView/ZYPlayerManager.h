//
//  HFPlayerManager.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/11.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HFPlayerPlayState) {//播放器播放状态
    HFPlayerPlayStateUnknown = 0,
    HFPlayerPlayStatePlaying,
    HFPlayerPlayStateBuffering,
    HFPlayerPlayStatePaused,
    HFPlayerPlayStateFailed,
    HFPlayerPlayStateStopped
};

typedef NS_ENUM(NSInteger, HFPlayerScalingMode) {
    HFPlayerScalingModeNone,       // No scaling.
    HFPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits.
    HFPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents.
    HFPlayerScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds.
};

@interface ZYPlayerManager : NSObject

@property (nonatomic, weak) UIView *view;

@property (nonatomic) HFPlayerScalingMode scalingMode;

@property (nonatomic, readonly) HFPlayerPlayState playState;

@property (nonatomic, strong) NSURL *assetURL;

@property (nonatomic, getter=isMuted) BOOL muted;

@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) NSTimeInterval totalTime;
@property (nonatomic, readonly) NSTimeInterval bufferTime;

@property (nonatomic) NSTimeInterval seekTime;

@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(NSTimeInterval currentTime, NSTimeInterval totalTime);
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(float bufferProgress, NSTimeInterval bufferTime, NSTimeInterval totalTime);
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(ZYPlayerManager *playerManager, HFPlayerPlayState playState);
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(NSURL *assetURL);

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (void)replay;
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end
