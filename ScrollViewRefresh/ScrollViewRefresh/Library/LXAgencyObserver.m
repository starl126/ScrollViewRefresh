//
//  LXObserver.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXAgencyObserver.h"

@implementation LXAgencyObserver

- (void)setLx_consignorView:(UIView *)lx_consignorView {
    _lx_consignorView = lx_consignorView;
    [lx_consignorView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        if (!CGPointEqualToPoint(point, CGPointZero) &&
            ((UIScrollView*)self.lx_consignorView).contentSize.height != 0) {
            //            NSLog(@"point = %@---%.2f---%.2f", NSStringFromCGPoint(point),self.bounds.size.height,((UIScrollView*)self).contentSize.height);
            BOOL position = point.y + self.lx_consignorView.bounds.size.height*1.3 > ((UIScrollView*)self.lx_consignorView).contentSize.height;
            if (position && !self.lx_requesting) {
                if (self.lx_needRequestBlock) {
                    self.lx_needRequestBlock();
                }
            }
        }
    }
}
- (void)dealloc {
    [_lx_consignorView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"_consignorView = %@", _lx_consignorView);
    NSLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
