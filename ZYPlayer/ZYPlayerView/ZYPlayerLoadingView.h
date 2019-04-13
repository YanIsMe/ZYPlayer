//
//  HFPlayerLoadingView.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYPlayerLoadingType) {
    ZYPlayerLoadingTypeKeep,
    ZYPlayerLoadingTypeFadeOut,
};

@interface ZYPlayerLoadingView : UIView

@property (nonatomic, assign) ZYPlayerLoadingType animType;
/// default is whiteColor.
@property (nonatomic, strong, null_resettable) UIColor *lineColor;

@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) BOOL hidesWhenStopped;
///  default is 1.5s.
@property (nonatomic, readwrite) NSTimeInterval duration;
/// anima state
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;


@end
