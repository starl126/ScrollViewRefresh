//
//  LXObserver.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXAgencyObserver.h"

@implementation LXAgencyObserver

- (void)setConsignorView:(UIView *)consignorView {
    _consignorView = consignorView;
    [consignorView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        if (!CGPointEqualToPoint(point, CGPointZero) &&
            ((UIScrollView*)self.consignorView).contentSize.height != 0) {
            //            NSLog(@"point = %@---%.2f---%.2f", NSStringFromCGPoint(point),self.bounds.size.height,((UIScrollView*)self).contentSize.height);
            BOOL position = point.y + self.consignorView.bounds.size.height*1.3 > ((UIScrollView*)self.consignorView).contentSize.height;
            if (position && !self.isRequesting) {
                if (self.needRequestBlock) {
                    self.needRequestBlock();
                }
            }
        }
    }
}
- (void)dealloc {
    [_consignorView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"_consignorView = %@", _consignorView);
    NSLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
