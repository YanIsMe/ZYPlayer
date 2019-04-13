//
//  HFPlayerView.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/6.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPlayerPlayAssetModel.h"
#import "ZYPlayerPlayEndView.h"

@class ZYPlayerView;

@protocol ZYPlayerViewDelegate <NSObject>

@optional

- (void)playerViewShareAction;
- (void)playerView:(ZYPlayerView *)playerView playDidEndAssetModel:(ZYPlayerPlayAssetModel *)assetModel;
- (void)playerView:(ZYPlayerView *)playerView hideControlView:(BOOL)hide;

@end

@interface ZYPlayerView : UIView

@property (nonatomic, weak)     id<ZYPlayerViewDelegate> delegate;
@property (nonatomic, readonly) BOOL fullScreen;
/** 播放结束页 */
@property (nonatomic, weak)     ZYPlayerPlayEndView *playEndView;
@property (nonatomic, readonly) BOOL statusBarHidden;
@property (nonatomic, readonly) NSIndexPath *playingIndexPath;

+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView containerViewTag:(NSInteger)containerViewTag;

- (void)playAssetURL:(NSURL *)assetURL coverURLString:(NSString *)coverUrl;
- (void)playAssetModel:(ZYPlayerPlayAssetModel *)assetModel;

- (void)stopCurrentPlayingCell;
- (void)play;
- (void)pause;
- (void)replay;

- (void)playRecord;

@end
