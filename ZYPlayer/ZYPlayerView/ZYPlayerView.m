//
//  HFPlayerView.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/6.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "ZYPlayerView.h"
#import "ZYPlayerControlView.h"
#import "ZYPlayerOrientationObserver.h"
#import "ZYPlayerManager.h"
#import "ZYPlayerScrollViewManager.h"

//#if __has_include("UIImageView+WebCache.h")
//#import "UIImageView+WebCache.h"
//#endif
//#import "UIImageView+WebCache.h"
#import "ZYPlayRecordManager.h"
#import "ZYPlayerUtilities.h"

@interface ZYPlayerView ()<ZYPlayerControlViewDelegate>

@property (nonatomic, strong) ZYPlayerControlView *controlView;
@property (nonatomic, strong) ZYPlayerOrientationObserver *orientationObserver;
@property (nonatomic, strong) ZYPlayerScrollViewManager *scrollViewManager;
@property (nonatomic, strong) ZYPlayerManager *playerManager;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, assign) BOOL  isPauseByUser;

@property (nonatomic, strong) NSMutableArray <ZYPlayerPlayAssetModel *>*assetModelArray;
@property (nonatomic, strong) ZYPlayerPlayAssetModel *currentAssetModel;

@end

@implementation ZYPlayerView

+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag
{
    ZYPlayerView *playerView = [[ZYPlayerView alloc] initWithFrame:CGRectMake(0, 0, HFPlayerScreenWidth, HFPlayerScreenWidth*9/16)];//默认16:9
    playerView.scrollViewManager.scrollView = scrollView;
    playerView.scrollViewManager.containerViewTag = containerViewTag;
    return playerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.coverImageView];
        [self addSubview:self.controlView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];// app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];// app进入前台
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverImageView.frame = self.bounds;
    self.controlView.frame = self.bounds;
    self.playerManager.view = self;
    if (self.playEndView && self.playEndView.superview) self.playEndView.frame = self.bounds;
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview;
{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIWindow class]]) return;
    [self.orientationObserver updateRotateView:self containerView:newSuperview];
}

#pragma mark - public

- (void)playAssetURL:(NSURL *)assetURL coverURLString:(NSString *)coverUrl
{
    ZYPlayerPlayAssetModel *assetModel = [[ZYPlayerPlayAssetModel alloc] init];
    assetModel.assetURL = assetURL;
    assetModel.coverURLString = coverUrl;
    [self playAssetModel:assetModel];
}

- (void)playAssetModel:(ZYPlayerPlayAssetModel *)assetModel
{
    [self playRecord];
    
    if (assetModel.indexPath) {
        self.scrollViewManager.playingIndexPath = assetModel.indexPath;
        UIView *containerView = [self.scrollViewManager getContainerViewFromCell];
        if (containerView == nil) {
            return;
        }
        [self removeFromSuperview];
        self.frame = containerView.bounds;
        [containerView addSubview:self];
    }
    if (self.superview == nil) {
        return;
    }
    NSTimeInterval recordSeek = [[ZYPlayRecordManager sharedManager] getPlayRecordForAssetPath:assetModel.assetURL.absoluteString];
    if (recordSeek > 0) {
        assetModel.seekTime = recordSeek;
    }
    
    [self.controlView resetControlView];
    self.coverImageView.hidden = NO;
    self.isPauseByUser = NO;
    [self.controlView playerPlayBtnState:YES];
    self.coverImageView.image = nil;
    
    //#if __has_include("UIImageView+WebCache.h")
    //[self.coverImageView sd_setImageWithURL:[NSURL URLWithString:assetModel.coverURLString]];
    //#endif
    
    if (self.playEndView && self.playEndView.superview) [self.playEndView removeFromSuperview];
    self.currentAssetModel = assetModel;
    self.playerManager.seekTime = assetModel.seekTime;
    self.playerManager.assetURL = assetModel.assetURL;
}

- (void)play;
{
    if (self.playerManager.playState == HFPlayerPlayStateStopped) return;
    self.isPauseByUser = NO;
    [self.controlView playerPlayBtnState:YES];
    [self.playerManager play];
}

- (void)pause;
{
    if (self.playerManager.playState == HFPlayerPlayStateStopped) return;
    self.isPauseByUser = YES;
    [self.controlView playerPlayBtnState:NO];
    [self.playerManager pause];
    
    [self playRecord];
}

- (void)replay
{
    self.isPauseByUser = NO;
    self.controlView.hidden = NO;
    [self.controlView playerPlayBtnState:YES];
    if (self.playEndView) [self.playEndView removeFromSuperview];
    [self.playerManager replay];
}

- (void)currentPlayDidEnd
{
    BOOL isDelay = self.fullScreen;
    if (self.fullScreen) {
        [self.orientationObserver enterPortraitFullScreen:NO animated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(playerView:playDidEndAssetModel:)]) {
        [self.delegate playerView:self playDidEndAssetModel:self.currentAssetModel];
    }
    if (self.playEndView) {
        self.controlView.hidden = YES;
        self.playEndView.frame = self.bounds;
        if (isDelay) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self addSubview:self.playEndView];
                 });
        } else {
            [self addSubview:self.playEndView];
        }
    }
    
    [[ZYPlayRecordManager sharedManager] removePlayRecordForAssetPath:self.playerManager.assetURL.absoluteString];
}

- (void)stopCurrentPlayingCell
{
    if (self.scrollViewManager.playingIndexPath) {
        [self playRecord];
        
        self.scrollViewManager.playingIndexPath = nil;
        [self removeFromSuperview];
        [self.playerManager stop];
    }
    if (self.playEndView && self.playEndView.superview) [self.playEndView removeFromSuperview];
}

- (void)playRecord
{
    if (self.playerManager.playState == HFPlayerPlayStateStopped) {
        return;
    }
    if (self.playerManager.assetURL) {
        [[ZYPlayRecordManager sharedManager] recordPlayWithAssetPath:self.playerManager.assetURL.absoluteString seekTime:self.playerManager.currentTime];
    }
}

#pragma mark - Notification

- (void)appDidEnterBackground
{
    [self.controlView playerPlayBtnState:NO];
    [self.playerManager pause];
}

- (void)appDidEnterPlayground
{
    if (!self.isPauseByUser && self.playerManager.playState != HFPlayerPlayStateStopped) {
        [self.controlView playerPlayBtnState:YES];
        [self.playerManager play];
    }
}

#pragma mark - ZYPlayerControlViewDelegate

- (void)controlViewBackAction
{
    if (self.fullScreen) {
        [self.orientationObserver enterPortraitFullScreen:NO animated:YES];
    }
}

- (void)controlViewShareAction
{
    if ([self.delegate respondsToSelector:@selector(playerViewShareAction)]) {
        [self.delegate playerViewShareAction];
    }
}

- (void)controlViewFailAction
{
    [self.controlView resetControlView];
    self.isPauseByUser = NO;
    [self.playerManager prepareToPlay];
}

- (void)controlView:(ZYPlayerControlView *)controlView playerPlayBtnState:(BOOL)state
{
    if (state) {
        [self.playerManager play];
    } else {
        [self.playerManager pause];
        self.isPauseByUser = YES;
    }
}

- (void)controlView:(ZYPlayerControlView *)controlView draggedVideoTime:(NSTimeInterval)draggedTime
{
    [self.playerManager seekToTime:draggedTime completionHandler:^(BOOL finished) {
        [controlView playerPlayBtnState:YES];
    }];
}

- (void)controlView:(ZYPlayerControlView *)controlView fullScreen:(BOOL)fullScreen
{
    [self.orientationObserver enterPortraitFullScreen:fullScreen animated:YES];
}

- (NSTimeInterval)currentPlayTimeWithControlView:(ZYPlayerControlView *)controlView
{
    return self.playerManager.currentTime;
}

- (void)controlView:(ZYPlayerControlView *)controlView hideUpDownControlView:(BOOL)hide;
{
    self.orientationObserver.statusBarHidden = hide;
    if ([self.delegate respondsToSelector:@selector(playerView:hideControlView:)]) {
        [self.delegate playerView:self hideControlView:hide];
    }
}

- (BOOL)shouldResponseGestureWithGestureType:(ZFPlayerGestureType)type touch:(UITouch *)touch
{
    if (type == ZFPlayerGestureTypePan) {
        if (self.fullScreen) return YES;
        if (_scrollViewManager) {
            if (self.scrollViewManager.scrollView) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - setter

- (void)setPlayEndView:(ZYPlayerPlayEndView *)playEndView
{
    _playEndView = playEndView;
    _playEndView.fullScreen = self.fullScreen;
}

#pragma mark - getter

- (BOOL)fullScreen
{
    return self.orientationObserver.fullScreen;
}

- (BOOL)statusBarHidden
{
    return self.orientationObserver.statusBarHidden;
}

- (NSIndexPath *)playingIndexPath
{
    return self.scrollViewManager.playingIndexPath;
}

- (ZYPlayerManager *)playerManager
{
    if (!_playerManager) {
        _playerManager = [[ZYPlayerManager alloc] init];
        _playerManager.view = self;
        __weak typeof(self) weakSelf = self;
        _playerManager.playerBufferTimeChanged = ^(float bufferProgress, NSTimeInterval bufferTime, NSTimeInterval totalTime) {
            [weakSelf.controlView setVideoBufferProgress:bufferProgress bufferTime:bufferTime totalTime:totalTime];
        };
        _playerManager.playerPlayTimeChanged = ^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
            [weakSelf.controlView setVideoCurrentTime:currentTime totalTime:totalTime];
        };
        _playerManager.playerPlayStateChanged = ^(ZYPlayerManager *playerManager, HFPlayerPlayState playState) {
            if (playState == HFPlayerPlayStatePlaying) {
                weakSelf.coverImageView.hidden = YES;
            }
            [weakSelf.controlView playStateChanged:playState];
        };
        _playerManager.playerDidToEnd = ^(NSURL *assetURL) {
            [weakSelf currentPlayDidEnd];
        };
        [self.controlView playerPlayBtnState:YES];
    }
    return _playerManager;
}

- (ZYPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[ZYPlayerControlView alloc] initWithFrame:self.bounds];
        [_controlView.gestureControl addGestureToView:self];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (ZYPlayerScrollViewManager *)scrollViewManager
{
    if (!_scrollViewManager) {
        _scrollViewManager = [[ZYPlayerScrollViewManager alloc] init];
        __weak typeof(self) weakSelf = self;
        _scrollViewManager.cellDisappearingInScrollView = ^(NSIndexPath *indexPath) {
            [weakSelf stopCurrentPlayingCell];
        };
        _scrollViewManager.scrollViewWillReload = ^(NSIndexPath *indexPath) {
            [weakSelf stopCurrentPlayingCell];
        };
    }
    return _scrollViewManager;
}

- (ZYPlayerOrientationObserver *)orientationObserver
{
    if (!_orientationObserver) {
        _orientationObserver = [[ZYPlayerOrientationObserver alloc] init];
        __weak typeof(self) weakSelf = self;
        _orientationObserver.orientationWillChange = ^(ZYPlayerOrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            weakSelf.controlView.fullScreen = isFullScreen;
            if (weakSelf.playEndView) {
                weakSelf.playEndView.fullScreen = isFullScreen;
            }
            weakSelf.scrollViewManager.fullScreen = isFullScreen;
        };
    }
    return _orientationObserver;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.jpg"]];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

@end
