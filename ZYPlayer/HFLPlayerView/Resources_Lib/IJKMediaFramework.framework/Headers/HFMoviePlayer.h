/*
 * HFMoviePlayer.h
 *
 * Copyright (c) 2017 HFLive
 * Copyright (c) 2017 Zhang Xiaolin
 *
 * This file is part of hfPlayer.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IJKMediaPlayer.h"

/**
 *  版本记录(临时)
 */
#define HFMediaPlayr_Version           "0.0.2.13"

typedef NS_ENUM(NSInteger,PlayerState)
{
    PLAYER_STATE_PREPARE,               // the player is prepared to play.
    PLAYER_STATE_PLAY,                  // the player is begin play and start render.(only used in living)
    PLAYER_STATE_BUFFEREMPTY,           // player's buffer is empty.
    PLAYER_STATE_BUFFERREADY,           // player's buffer is ready and have enough buffer to play.
    PLAYER_STATE_LOADTIMEUPDATE,        // player's buffer is buffering.
    PLAYER_STATE_KEYFRAME,              // got a keyframe(only used in living)
    PLAYER_STATE_TIMEOUT,               // player's buffer is timeout.
    PLAYER_STATE_COMPLETED,             // play a file is ended, or user end the play
    PLAYER_STATE_ERROR,                 // play a file occure a error.
    PLAYER_STATE_SHUTDOWN               // reserved, not used now
};

@protocol PlayerStateDelegate <NSObject>

@optional

/**
 @abstract               播放器状态回调
 @discussion PlayerState 播放器回调的状态值
 */
-(void) onPlayerStateChanged:(PlayerState) playerState;

@end

@interface HFMoviePlayer : NSObject

/*
 * 播放器类型
 * TYPE_UNKNOW_PLAYER   未知类型
 * TYPE_FFMOIVE_PLAYER  FFplayer播放器（直播）
 * TYPE_AVMOIVE_PLAYER  AVPlayer播放器(点播)
 * TYPE_MPMOIVE_PLAYER  MPMoviePlayer播放器,iOS9之后被弃用
 * HFMoviePlayer封装了IJKMediaPlayer和AVPlayer，对app提供统一接口。
 */
typedef enum HFPlayerType {
    TYPE_UNKNOW_PLAYER  = 0,
    TYPE_FFMOIVE_PLAYER = 1,
    TYPE_AVMOIVE_PLAYER = 2,
    TYPE_MPMOIVE_PLAYER = 3,
} HFPlayerType;

@property(nonatomic, strong) NSURL*             url;            // 拉流地址

@property(nonatomic,weak) id<PlayerStateDelegate> delegate;

/**
 @abstract       播放器初始化
 @discussion mid 本机的机器码
 */

- (id)init:(NSString*)mid;

/**
 @abstract        设置埋点地址
 @discussion aUrl 播放文件的地址
 */
- (void)setPlayerReportParam:(NSString *)strUrl;

/**
 @abstract       设置播放地址
 @discussion aUrl 播放文件的地址
 @discussion type 播放文件类型（直播：TYPE_FFMOIVE_PLAYER   点播：TYPE_AVMOIVE_PLAYER）
 */
- (BOOL)setContentURL:(NSURL *)aUrl
             withType:(HFPlayerType)type;

- (void)reset;

/**
 @abstract               设置播放view
 @discussion playerView  显示视频的view
 */
- (void)setView:(UIView *)playerView;

- (void)removeView;

/**
 @abstract               准备播放
 @note                   该函数在setContentURL的时候已有内部调用，app无需再次调用该函数
 */
- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPauseInBackground:(BOOL)pause;
- (void)mute:(BOOL)mute;

- (void)setBufferTimeOut:(UInt64)bufferTimeOut;

/**
 @abstract                          设置显示视频拉升模式
 @discussion IJKMPMovieScalingMode  指定拉升模式
 */
- (void)setScalingMode: (IJKMPMovieScalingMode) aScalingMode;

- (NSTimeInterval)currentPlaybackTime;

- (NSTimeInterval)duration;

- (NSTimeInterval)playableDuration;

/**
 @abstract                          设置播放时间点（需要seek的时候调用）
 @discussion aCurrentPlaybackTime   播放的时间点
 */
- (void)setCurrentPlaybackTime:(NSTimeInterval)aCurrentPlaybackTime;

- (void)setPlaybackVolume:(float)volume;

- (float)playbackVolume;

// 挂起播放器，挂起状态下播放器的错误、超时不会回调到上层
//-(void) onSuspend:(BOOL)bSuspend;
@end

