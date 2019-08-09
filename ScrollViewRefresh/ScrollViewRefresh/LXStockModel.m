//
//  LXStockModel.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/2.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXStockModel.h"

@implementation LXStockModel

- (instancetype)init {
    if (self = [super init]) {
//        NSLog(@"111-%@", NSStringFromClass(self.class));
//        NSLog(@"222-%@", NSStringFromClass(super.class));
    }
    return self;
}
- (void)setApplyTime:(NSString *)applyTime {
    _applyTime = applyTime.copy;
}
- (NSString *)applyTime {
    return _applyTime;
}

@end
