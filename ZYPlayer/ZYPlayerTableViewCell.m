//
//  ZYPlayerTableViewCell.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/4/13.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import "ZYPlayerTableViewCell.h"

@implementation ZYPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)palyAction:(id)sender
{
    if (self.cellPlayTheVideo) {
        __weak typeof(self) weakSelf = self;
        ZYPlayerPlayAssetModel *assetModel = [[ZYPlayerPlayAssetModel alloc] init];
        assetModel.assetURL = [NSURL URLWithString: @"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"];
        //assetModel.coverURLString = [UIImageView lf_imageURLAppendingWithURLString:weakSelf.worksModel.coverImg rulesType:LFImageLoadRulesType_1125x630];
        assetModel.indexPath = weakSelf.indexPath;
        weakSelf.cellPlayTheVideo(assetModel);
    }
}

@end
