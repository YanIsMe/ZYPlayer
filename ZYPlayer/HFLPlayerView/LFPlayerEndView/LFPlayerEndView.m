//
//  LFPlayerEndView.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/14.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import "LFPlayerEndView.h"
#import "ZYPlayerUtilities.h"

@interface LFPlayerEndView()

@property (nonatomic, strong) UIButton *repeatBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation LFPlayerEndView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _repeatBtn.center = CGPointMake(self.centerX - ((91/2)+15), self.centerY);
    _shareBtn.center  = CGPointMake(self.centerX + ((91/2)+15), self.centerY);
}

- (void)initSubViews
{
    _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _repeatBtn.frame = CGRectMake(0, 0, 91, 33.5);
    _repeatBtn.center = CGPointMake(self.centerX - ((91/2)+15), self.centerY);
    [_repeatBtn setImage:[UIImage imageNamed:@"btn_replay"] forState:UIControlStateNormal];
    [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.repeatBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(0, 0, 91, 33.5);
    _shareBtn.center = CGPointMake(self.centerX + ((91/2)+15), self.centerY);
    [_shareBtn setImage:[UIImage imageNamed:@"player_end_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareBtn];
}

- (void)repeatBtnClick:(UIButton *)btn
{
    if (self.repeatBtnClick != nil) {
        self.repeatBtnClick();
    }
}

- (void)shareBtnClick:(UIButton *)btn
{
    if (self.shareBtnClick != nil) {
        self.shareBtnClick();
    }
}

@end
