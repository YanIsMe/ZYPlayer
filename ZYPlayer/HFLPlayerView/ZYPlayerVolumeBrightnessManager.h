//
//  HFPlayerVolumeBrightnessManager.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/12.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZYPlayerVolumeBrightnessType) {
    ZYPlayerVolumeBrightnessTypeVolume,       // volume
    ZYPlayerVolumeBrightnessTypeumeBrightness // brightness
};

@interface ZYPlayerBrightnessView : UIView
@end

@interface ZYPlayerVolumeBrightnessManager : NSObject

@property (nonatomic) float brightness;
@property (nonatomic) float volume;

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(ZYPlayerVolumeBrightnessType)volumeBrightnessType;
- (void)updateLayout;


@end
