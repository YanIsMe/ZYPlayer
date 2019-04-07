//
//  HFLPlayRecordManager.h
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/12/20.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYPlayRecordManager : NSObject

+ (instancetype)sharedManager;

- (void)recordPlayWithAssetPath:(NSString *)assetPath seekTime:(NSTimeInterval)seekTime;
- (NSTimeInterval)getPlayRecordForAssetPath:(NSString *)assetPath;
- (void)removePlayRecordForAssetPath:(NSString *)assetPath;

@end


