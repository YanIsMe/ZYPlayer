//
//  ZYPlayerTableViewCell.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/4/13.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPlayerPlayAssetModel.h"

#define PlayContainerViewTag  615

NS_ASSUME_NONNULL_BEGIN

@interface ZYPlayerTableViewCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^cellPlayTheVideo)(ZYPlayerPlayAssetModel *assetModel);

@end

NS_ASSUME_NONNULL_END
