//
//  LXViewController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXViewController.h"
#import "ViewController.h"

@interface LXViewController ()

@end

@implementation LXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController* vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
