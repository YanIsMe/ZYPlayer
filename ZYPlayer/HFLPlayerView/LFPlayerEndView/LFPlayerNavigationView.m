//
//  LFPlayerNavigationView.m
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/19.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import "LFPlayerNavigationView.h"
#import "ZYPlayerUtilities.h"

@interface LFPlayerNavigationView ()

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation LFPlayerNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.backBtn];
        [self addSubview:self.moreButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topImageView.bounds = self.bounds;
    self.backBtn.frame = CGRectMake(0, self.height - 40, 40, 40);
    
    self.moreButton.right   = self.width;
    self.moreButton.centerY = self.backBtn.centerY;
}
#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(playerBackAction)]) {
        [self.delegate playerBackAction];
    }
}

-(void)moreButtonAction
{
    if ([self.delegate respondsToSelector:@selector(moreClickAction)]) {
        [self.delegate moreClickAction];
    }
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 1;
        _topImageView.image                  = HFPlayerImage(@"ZFPlayer_top_shadow");
        _topImageView.hidden                 = YES;
    }
    return _topImageView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:HFPlayerImage(@"ZFPlayer_back_jiantou") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        [_moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_moreButton setImage:[UIImage imageNamed:@"icon_dian2_gengduo_w"] forState:(UIControlStateNormal)];
    }
    return _moreButton;
}

@end
