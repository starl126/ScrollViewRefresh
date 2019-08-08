//
//  LXStockModel.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/2.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXStockModel.h"

@implementation LXStockModel

- (void)setApplyTime:(NSString *)applyTime {
    _applyTime = applyTime.copy;
}
- (NSString *)applyTime {
    return _applyTime;
}

@end
