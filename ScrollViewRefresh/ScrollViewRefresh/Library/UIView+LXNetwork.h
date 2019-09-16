//
//  UIView+Network.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXNetworkConfigureProtocol.h"

NS_ASSUME_NONNULL_BEGIN
///封装网络请求
@interface UIView (LXNetwork)

///设置代理，只有在代理不为nil时才能使用
@property (nonatomic, weak) id<LXNetworkConfigureProtocol> lx_delegate;
///数组类型数据，数组元素可能是自定义model类型，也可能是纯数组,只用于分页数据类型
@property (nonatomic, strong, readonly) NSMutableArray* lx_dataSourceArrM;
///请求数据，如果是分页，则是请求第一页数据；如果不是分页，则请求所有数据
- (void)lx_requestData;
///释放观察者对象,必须在当前控件销毁前调用。在实现了LXNetworkConfigureProtocol的代理方法lx_requestTwiceOneTime返回yes时才有必要调用
- (void)lx_releaseObsever;

@end

NS_ASSUME_NONNULL_END
