//
//  HFLPlayRecordManager.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2018/12/20.
//  Copyright © 2018 Starunion. All rights reserved.
//

#import "ZYPlayRecordManager.h"
#import "NSString+ZYSecret.h"

@interface ZYPlayRecordManager ()

@property (nonatomic, strong) NSMutableDictionary *recordDic;
@property (nonatomic, strong) NSMutableArray *recordArray;

@end

static NSInteger MaxRecordCount = 100;

@implementation ZYPlayRecordManager

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)recordPlayWithAssetPath:(NSString *)assetPath seekTime:(NSTimeInterval)seekTime
{
    if (assetPath && assetPath.length > 0 && seekTime > 0) {
        NSString *pathMD5 = assetPath.MD5String;
        [self.recordDic setValue:[NSNumber numberWithDouble:seekTime] forKey:pathMD5];
    }
}

- (NSTimeInterval)getPlayRecordForAssetPath:(NSString *)assetPath
{
    if (assetPath && assetPath.length > 0) {
        NSString *pathMD5 = assetPath.MD5String;
        NSNumber *number = [self.recordDic objectForKey:pathMD5];
        if (number) {
            return number.doubleValue;
        }
    }
    return 0;
}

- (void)removePlayRecordForAssetPath:(NSString *)assetPath
{
    if (assetPath && assetPath.length > 0) {
        NSString *pathMD5 = assetPath.MD5String;
        [self.recordDic removeObjectForKey:pathMD5];
    }
}


- (NSMutableDictionary *)recordDic
{
    if (!_recordDic) {
        _recordDic = [[NSMutableDictionary alloc] init];
    }
    return _recordDic;
}

- (NSMutableArray *)recordArray
{
    if (!_recordArray) {
        _recordArray = [[NSMutableArray alloc] init];
    }
    return _recordArray;
}

@end
