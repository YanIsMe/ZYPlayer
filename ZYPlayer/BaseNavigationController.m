//
//  BaseNavigationController.m
//  ZYPlayer
//
//  Created by ZhaoYan on 2019/4/8.
//  Copyright © 2019 ZhaoYan. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    //在viewControllers中返回需要改变的viewController
    return [[self.viewControllers lastObject] shouldAutorotate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
