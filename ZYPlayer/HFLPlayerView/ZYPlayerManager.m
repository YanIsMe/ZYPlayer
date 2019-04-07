//
//  HFPlayerManager.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/11.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import <IJKMediaFramework/HFMoviePlayer.h>

@interface ZYPlayerManager () <PlayerStateDelegate>

@property (nonatomic, assign) HFPlayerPlayState playState;
@property (nonatomic, strong) HFMoviePlayer *player;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) NSTimeInterval recordseekTime;
@property (nonatomic, assign) BOOL seekPlay;

@end

@implementation ZYPlayerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scalingMode = HFPlayerScalingModeAspectFit;
        
        _recordseekTime = 0;
        _seekPlay = NO;
        _seekTime = 0;
    }
    return self;
}

- (void)dealloc
{
    [self releasePlayer];
}

- (void)releasePlayer
{
    if (self.player) {
        [self.player shutdown];
        self.player = nil;
    }
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

- (void)configPlayer
{
    [self releasePlayer];
    NSString *deviceToken = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    self.player = [[HFMoviePlayer alloc] init:deviceToken];
    NSString* report_url = @"https://ha.bizrun.cn/pull_stream_log?";
    [self.player setPlayerReportParam:report_url];
    BOOL isCheck = [self.player setContentURL:self.assetURL withType:TYPE_AVMOIVE_PLAYER];
    if (!isCheck) {//校验失败
        self.playState = HFPlayerPlayStateFailed;
        return;
    }
    self.player.delegate = self;
    [self createTimer];
    self.playState = HFPlayerPlayStateBuffering;
    [self.player play];
}

- (void)createTimer
{
    __weak typeof(self) weakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSTimeInterval totalTime = weakSelf.player.duration>0?weakSelf.player.duration:1;
        NSTimeInterval currentTime;
        currentTime = weakSelf.player.currentPlaybackTime;
        CGFloat value ;
        if (totalTime > 0) {
            value = (CGFloat)currentTime / totalTime;
        } else {
            value = 0.0f;
        }
        // 计算缓冲进度
        NSTimeInterval timeInterval = [weakSelf bufferTime];
        float bufferProgress = MIN(ceilf(timeInterval)/ floor(totalTime), 1);
        if (weakSelf.playerBufferTimeChanged) {
            weakSelf.playerBufferTimeChanged(bufferProgress, timeInterval, [weakSelf totalTime]);
        }
        if (weakSelf.playerPlayTimeChanged) {
            weakSelf.playerPlayTimeChanged([weakSelf currentTime], [weakSelf totalTime]);
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 播放操作

- (void)prepareToPlay
{
    if (!_assetURL)  {
        self.playState = HFPlayerPlayStateFailed;
        [self releasePlayer];
        return;
    }
    [self configPlayer];
    //    if (_playerPrepareToPlay) _playerPrepareToPlay(self, self.assetURL);
    //    [self play];
}

- (void)play
{
    if (self.playState == HFPlayerPlayStatePaused) self.playState = HFPlayerPlayStatePlaying;
    [self.player play];
}

- (void)pause
{
    if (self.playState == HFPlayerPlayStatePlaying) self.playState = HFPlayerPlayStatePaused;
    [self.player pause];
}

- (void)stop
{
    [self releasePlayer];
    self.playState = HFPlayerPlayStateStopped;
}

- (void)replay
{
    if (!_assetURL) return;
    __weak typeof(self) weakSelf = self;
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        [weakSelf play];
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.playState == HFPlayerPlayStateFailed) {
        if (completionHandler) completionHandler(NO);
        return;
    }
    NSTimeInterval willsSeekTime = time;
    if (willsSeekTime > [self totalTime]) {
        willsSeekTime = [self totalTime];
    }
    self.recordseekTime = willsSeekTime;
    self.seekPlay = YES;
    [self.player setCurrentPlaybackTime:willsSeekTime];
   // if (self.player.currentPlaybackTime + time > self.player.playableDuration){
        self.playState = HFPlayerPlayStateBuffering;
//    }else{
//        self.playState = HFPlayerPlayStatePlaying;
//    }
    [self.player play];
    if (completionHandler) completionHandler(YES);
}

#pragma mark - PlayerStateDelegate

-(void) onPlayerStateChanged:(PlayerState) playerState;
{
    switch (playerState) {
        case PLAYER_STATE_PREPARE:
        {
            [self.player setView:self.view];
            if (self.playState != HFPlayerPlayStateStopped)
            self.playState = HFPlayerPlayStatePlaying;
            
            NSLog(@"totalTime: %lf",[self totalTime]);
            // 跳到xx秒播放视频
            if (self.seekTime > 0) {
                [self seekToTime:self.seekTime completionHandler:nil];
                self.seekTime = 0;
            }
            
            [self.player mute:self.muted];
            break;
        }
        case PLAYER_STATE_ERROR:
        {
            if(self.playState != HFPlayerPlayStateStopped)
            self.playState = HFPlayerPlayStateFailed;
            break;
        }
        case PLAYER_STATE_COMPLETED://播放结束
            self.playState = HFPlayerPlayStateStopped;
//            [self.player stop];
            if (self.playerDidToEnd) {
                self.playerDidToEnd(self.assetURL);
            }
            NSLog(@"zxl PLAYER_STATE_COMPLETED Stop");
            break;
        case PLAYER_STATE_BUFFEREMPTY:
        {
            break;
        }
        case PLAYER_STATE_BUFFERREADY:
        {
            if (self.playState == HFPlayerPlayStateBuffering){
                self.playState = HFPlayerPlayStatePlaying;
                NSLog(@"可以播放了");
            }
            self.recordseekTime = 0;
            self.seekPlay = NO;
            break;
        }
        case PLAYER_STATE_LOADTIMEUPDATE:
            if (self.playState != HFPlayerPlayStateStopped) {
                if (self.player.playableDuration  < self.player.currentPlaybackTime) {
                    self.playState = HFPlayerPlayStateBuffering;
                } else {
                    self.playState = HFPlayerPlayStatePlaying;
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (NSTimeInterval)totalTime
{
    return self.player.duration;
}

- (NSTimeInterval)currentTime
{
    if (self.seekPlay) {
        return self.recordseekTime;
    }
    return self.player.currentPlaybackTime;
}

- (NSTimeInterval)bufferTime
{
    return self.player.playableDuration;
}

#pragma mark - setter

- (void)setView:(UIView *)view
{
    _view = view;
    if (self.player) {
        [self.player setView:view];
    }
}

- (void)setAssetURL:(NSURL *)assetURL
{
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setPlayState:(HFPlayerPlayState)playState
{
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setScalingMode:(HFPlayerScalingMode)scalingMode
{
    _scalingMode = scalingMode;
    switch (scalingMode) {
        case HFPlayerScalingModeAspectFit:
            [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            break;
        case HFPlayerScalingModeAspectFill:
            [self.player setScalingMode:IJKMPMovieScalingModeAspectFill];
            break;
        case HFPlayerScalingModeFill:
            [self.player setScalingMode:IJKMPMovieScalingModeFill];
            break;
        default:
            [self.player setScalingMode:IJKMPMovieScalingModeNone];
            _scalingMode = HFPlayerScalingModeNone;
            break;
    }
}

- (void)setMuted:(BOOL)muted
{
    _muted = muted;
    [self.player mute:muted];
}

@end
