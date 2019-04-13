//
//  PlayListViewController.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/4/13.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import "PlayListViewController.h"
#import "ZYPlayerTableViewCell.h"
#import "ZYPlayerView.h"
#import "LFPlayerEndView.h"

@interface PlayListViewController () <ZYPlayerViewDelegate>

@property (nonatomic, strong) ZYPlayerView *playerView;
@property (nonatomic, strong) LFPlayerEndView *playEndView;

@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"ZYPlayerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZYPlayerTableViewCell"];
    [self configurationPlayer];
}

- (void)configurationPlayer
{
    self.playerView = [ZYPlayerView playerWithScrollView:self.tableView containerViewTag:PlayContainerViewTag];
    self.playerView.delegate = self;
    LFPlayerEndView *endView = [[LFPlayerEndView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    endView.shareBtnClick = ^{
        NSLog(@"点击了第%ldcell的分享",weakSelf.playerView.playingIndexPath.row);
    };
    endView.repeatBtnClick = ^{
        [weakSelf.playerView replay];
    };
    self.playEndView = endView;
    self.playerView.playEndView = endView;
}

- (BOOL)prefersStatusBarHidden
{
    return self.playerView.statusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZYPlayerViewDelegate

- (void)playerView:(ZYPlayerView *)playerView hideControlView:(BOOL)hide
{
    
}

- (void)playerView:(ZYPlayerView *)playerView playDidEndAssetModel:(ZYPlayerPlayAssetModel *)assetModel
{
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYPlayerTableViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.cellPlayTheVideo = ^(ZYPlayerPlayAssetModel * _Nonnull assetModel) {
        if (assetModel) {
            [weakSelf.playerView playAssetModel:assetModel];
        }
    };
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
