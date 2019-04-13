//
//  HFPlayerFastView.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/7.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPlayerFastView : UIView

@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, assign) BOOL forward;
@property (nonatomic, assign) float progress;

@end
