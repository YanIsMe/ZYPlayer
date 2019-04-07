//
//  UIScrollView+ZYPlayer.m
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/7.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import "UIScrollView+ZYPlayer.h"
#import <objc/runtime.h>

@implementation UIScrollView (ZYPlayer)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod([UICollectionView class], @selector(reloadData));
        Method toMethod = class_getInstanceMethod([self class], @selector(zyPlayerReloadData));
        if (!class_addMethod([self class], @selector(zyPlayerReloadData), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
            method_exchangeImplementations(fromMethod, toMethod);
        }
    });
}

- (void)zyPlayerReloadData
{
    if (self.playerReloadData) {
        self.playerReloadData();
    }
    [self zyPlayerReloadData];
}

- (BOOL)isTableView
{
    return [self isKindOfClass:[UITableView class]];
}

- (BOOL)isCollectionView
{
    return [self isKindOfClass:[UICollectionView class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.shouldRecognizeSimultaneously) {
      return self.shouldRecognizeSimultaneously(gestureRecognizer, otherGestureRecognizer);
    }
    return NO;
}

#pragma mark - getter/setter

- (NSIndexPath *)playingIndexPath
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(void))playerReloadData
{
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL (^)(UIGestureRecognizer * _Nonnull, UIGestureRecognizer * _Nonnull))shouldRecognizeSimultaneously
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlayingIndexPath:(NSIndexPath *)playingIndexPath
{
    objc_setAssociatedObject(self, @selector(playingIndexPath), playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //if (zf_playingIndexPath) self.zf_shouldPlayIndexPath = zf_playingIndexPath;
}

- (void)setPlayerReloadData:(void (^)(void))playerReloadData
{
    objc_setAssociatedObject(self, @selector(playerReloadData), playerReloadData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setShouldRecognizeSimultaneously:(BOOL (^)(UIGestureRecognizer * _Nonnull, UIGestureRecognizer * _Nonnull))shouldRecognizeSimultaneously
{
    objc_setAssociatedObject(self, @selector(shouldRecognizeSimultaneously), shouldRecognizeSimultaneously, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
