//
//  HFPlayerPlayAssetModel.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/9/13.
//  Copyright © 2018年 ZhaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYPlayerPlayAssetModel : NSObject

@property (nonatomic, strong) NSURL        *assetURL;
@property (nonatomic, copy)   NSString     *coverURLString;
@property (nonatomic, assign) NSTimeInterval seekTime;
/** 自定义所要数据 非必传 */
@property (nonatomic, strong) NSDictionary *customDataDic;

#pragma mark - cell播放
/** cell所在的indexPath */
@property (nonatomic, strong) NSIndexPath  *indexPath;


@end
