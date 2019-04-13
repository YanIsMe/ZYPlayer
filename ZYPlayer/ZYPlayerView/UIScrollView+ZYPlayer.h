//
//  UIScrollView+ZYPlayer.h
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/7.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZYPlayer)

@property (nonatomic, nullable) NSIndexPath *playingIndexPath;
@property (nonatomic, copy) void(^playerReloadData)(void);
@property (nonatomic, copy, nullable) BOOL(^shouldRecognizeSimultaneously)(UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer);

- (BOOL)isTableView;
- (BOOL)isCollectionView;

@end

NS_ASSUME_NONNULL_END
