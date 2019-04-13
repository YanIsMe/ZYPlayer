//
//  LFPlayerEndView.h
//  Leaflet
//
//  Created by Mr.Zhang on 2018/9/14.
//  Copyright © 2018年 Starunion. All rights reserved.
//

#import "ZYPlayerPlayEndView.h"

@interface LFPlayerEndView : ZYPlayerPlayEndView

@property (nonatomic, copy) void (^shareBtnClick)(void);

@property (nonatomic, copy) void (^repeatBtnClick)(void);

@end
