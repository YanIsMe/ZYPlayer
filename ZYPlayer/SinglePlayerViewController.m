//
//  SinglePlayerViewController.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/4/8.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "ZYPlayerView.h"
#import "LFPlayerEndView.h"

@interface SinglePlayerViewController () <ZYPlayerViewDelegate>

@property (nonatomic, strong) UIView           *containerView;
@property (nonatomic, strong) ZYPlayerView     *playerView;
@property (nonatomic, strong) LFPlayerEndView  *playEndView;//自定义结束页

@end

@implementation SinglePlayerViewController

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self configurationPlayer];
    
    NSString *videoUrlString = @"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4";
    [self.playerView playAssetURL:[NSURL URLWithString:videoUrlString] coverURLString:kVideoCover];
}

- (void)configurationPlayer
{
    self.playerView = [[ZYPlayerView alloc] initWithFrame:self.containerView.bounds];
    self.playerView.delegate = self;
    self.playerView.playEndView = self.playEndView;
    [self.containerView addSubview:self.playerView];
}

- (BOOL)prefersStatusBarHidden
{
    if (self.playerView.fullScreen) {
        return self.playerView.statusBarHidden;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZYPlayerViewDelegate

- (void)playerView:(ZYPlayerView *)playerView hideControlView:(BOOL)hide
{
    
}

- (void)playerView:(ZYPlayerView *)playerView playDidEndAssetModel:(ZYPlayerPlayAssetModel *)assetModel
{
    
}

#pragma mark - getter

- (UIView *)containerView
{
    if (!_containerView) {
            CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight(statusRect), CGRectGetWidth(self.view.bounds), 220)];
    }
    return _containerView;
}

- (LFPlayerEndView *)playEndView
{
    if (!_playEndView) {
        LFPlayerEndView *playEndView = [[LFPlayerEndView alloc]initWithFrame:self.containerView.bounds];
        __weak typeof(self) weakSelf = self;
        [playEndView setShareBtnClick:^{
            
        }];
        [playEndView setRepeatBtnClick:^{
            [weakSelf.playerView replay];
        }];
        _playEndView = playEndView;
    }
    return _playEndView;
}

@end
