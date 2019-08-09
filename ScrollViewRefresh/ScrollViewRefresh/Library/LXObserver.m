//
//  LXObserver.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXObserver.h"

@implementation LXObserver

- (void)setObv:(UIView *)obv {
    _obv = obv;
    [obv addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        CGPoint point = [change[@"new"] CGPointValue];
//        if (!CGPointEqualToPoint(point, CGPointZero) &&
//            ((UIScrollView*)self).contentSize.height != 0) {
//            //            NSLog(@"point = %@---%.2f---%.2f", NSStringFromCGPoint(point),self.bounds.size.height,((UIScrollView*)self).contentSize.height);
//            BOOL position = point.y + self.bounds.size.height*1.3 > ((UIScrollView*)self).contentSize.height;
//            if (position && !self.isRequesting) {
//                [self lx_actionForPullUpRefresh];
//            }
//        }
    }
}
- (void)dealloc {
    [_obv removeObserver:self.obv forKeyPath:@"contentOffset"];
    NSLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

@end
