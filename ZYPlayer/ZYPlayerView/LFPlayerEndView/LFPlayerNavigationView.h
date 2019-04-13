//
//  LFPlayerNavigationView.h
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/19.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFPlayerNavigationViewDelegate <NSObject>

@optional

- (void)playerBackAction;
- (void)moreClickAction;

@end


@interface LFPlayerNavigationView : UIView

@property (nonatomic, weak)     id<LFPlayerNavigationViewDelegate> delegate;

@end

