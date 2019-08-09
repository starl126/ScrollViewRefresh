//
//  LXObserver.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///代理观察者
@interface LXAgencyObserver : NSObject

///委托者控件
@property (nonatomic, weak) UIView* consignorView;
///是否正在请求网络中
@property (nonatomic, assign, getter=isRequesting) BOOL requesting;
///请求网络事件回调
@property (nonatomic, copy) dispatch_block_t needRequestBlock;

@end

NS_ASSUME_NONNULL_END
