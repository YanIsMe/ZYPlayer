//
//  NSString+ZYSecret.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/3/14.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import "NSString+ZYSecret.h"
#import <Security/Security.h>
#import <math.h>
#import <CommonCrypto/CommonCrypto.h>
#import <Accelerate/Accelerate.h>

@implementation NSString (ZYSecret)

- (NSString *)MD5String
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
