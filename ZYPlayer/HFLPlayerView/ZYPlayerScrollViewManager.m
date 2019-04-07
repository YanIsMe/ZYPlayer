//
//  HFPlayerScrollViewManager.m
//  Leaflet
//
//  Created by ZhaoYan on 2018/12/18.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import "ZYPlayerScrollViewManager.h"
#import "UIScrollView+ZYPlayer.h"

@interface ZYPlayerScrollViewManager ()

@property (nonatomic) BOOL scrollsToTop;

@end

#define ZYPlayerViewContentOffset   @"contentOffset"

@implementation ZYPlayerScrollViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.scrollView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.scrollView) {
        if ([keyPath isEqualToString:ZYPlayerViewContentOffset]) {
            [self handleScrollOffsetWithDict:change];
        }
    }
}

- (void)handleScrollOffsetWithDict:(NSDictionary*)dict
{
    if (self.playingIndexPath == nil) return;
    if ([self.scrollView isTableView]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.playingIndexPath];
        NSArray *visableCells = tableView.visibleCells;
        if ([visableCells containsObject:cell]) {
            // 在显示中
           
        } else {
            if (self.cellDisappearingInScrollView) {
                self.cellDisappearingInScrollView(self.playingIndexPath);
            }
        }
    } else if ([self.scrollView isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.playingIndexPath];
        if ( [collectionView.visibleCells containsObject:cell]) {
            // 在显示中
            //[self updatePlayerViewToCell];
        } else {
            if (self.cellDisappearingInScrollView) {
                self.cellDisappearingInScrollView(self.playingIndexPath);
            }
        }
    }
}

- (UIView *)getContainerViewFromCell
{
    if (self.playingIndexPath == nil || self.containerViewTag == 0) return nil;
    if ([self.scrollView isTableView]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.playingIndexPath];
        return [cell viewWithTag:self.containerViewTag];
    } else if ([self.scrollView isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.playingIndexPath];
        return [cell viewWithTag:self.containerViewTag];
    }
    return nil;
}

#pragma mark - setter

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) return;
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:ZYPlayerViewContentOffset];
    }
    _scrollView = scrollView;
    if (scrollView) {
        [scrollView addObserver:self forKeyPath:ZYPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
        __weak typeof(self) weakSelf = self;
        [scrollView setPlayerReloadData:^{
            if (weakSelf.scrollViewWillReload) {
                weakSelf.scrollViewWillReload(weakSelf.playingIndexPath);
            }
        }];
        self.scrollsToTop = scrollView.scrollsToTop;
    }
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    if (self.scrollView) {
        if (fullScreen) {
            self.scrollView.scrollsToTop = NO;
        } else {
            self.scrollView.scrollsToTop = self.scrollsToTop;
        }
    }
}

@end
