//
//  HFPlayerScrollViewManager.h
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/18.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYPlayerScrollViewManager : NSObject

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) NSIndexPath *playingIndexPath;
@property (nonatomic, assign) NSInteger containerViewTag;
@property (nonatomic, assign) BOOL fullScreen;

@property (nonatomic, copy) void(^cellDisappearingInScrollView)(NSIndexPath *indexPath);
@property (nonatomic, copy) void(^scrollViewWillReload)(NSIndexPath *indexPath);
@property (nonatomic, copy) void(^scrollViewDidReload)(NSIndexPath *indexPath);

- (UIView *)getContainerViewFromCell;

@end

