//
//  LXNetworkConfigureProtocol.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/7/23.
//  Copyright © 2019 starxin. All rights reserved.
//

#ifndef LXNetworkConfigureProtocol_h
#define LXNetworkConfigureProtocol_h
typedef NS_ENUM(NSUInteger, LXMethodOption) {
    LXMethodOptionGet = 0,
    LXMethodOptionPost = 1,
    LXMethodOptionDelete = 2,
    LXMethodOptionPut = 3,
    LXMethodOptionHead = 4,
};
typedef NS_ENUM(NSUInteger, LXRefreshOption) {
    LXRefreshOptionNone = 0,
    LXRefreshOptionHeader = 1,
    LXRefreshOptionFooter = 2,
    LXRefreshOptionHeaderFooter = 3,
};

@protocol LXNetworkConfigureProtocol <NSObject>

@required
///网络请求的url地址,必传参数
- (nonnull NSString*)lx_url;
///是否是分页数据
- (BOOL)lx_isPageData;

///请求非分页网络数据成功
- (void)lx_successRequestData:(nullable id)responseData url:(nonnull NSString*)url;
///请求分页网络数据成功,curArr：当前页的数组数据 totalArr：所有的数组数据包括当前页的数据在内
- (void)lx_successRequestCurrentPageData:(nullable NSArray*)curArr totalData:(nullable NSArray*)totalArr url:(nonnull NSString*)url;
///请求网络数据失败
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(nonnull NSString*)url;

@optional
///网络请求Method类型：'GET','PUT','POST','DELETE'，默认是'POST'请求
- (LXMethodOption)lx_methodOption;

///网络请求的参数
- (nullable id)lx_parameters;

///针对分页数据，每页请求的条数,若没有设置则默认10条
- (NSUInteger)lx_pageSize;
///针对分页数据，每页请求分页字段名，默认是'pageSize'
- (nullable NSString*)lx_pageSizeName;

///请求头的设置
- (nullable NSDictionary*)lx_requestHeaderFiled;

///数据对应的模型
- (nullable Class)lx_dataClass;

///设置刷新类型，默认是LXRefreshOptionNone
- (LXRefreshOption)lx_refreshOption;

///请求数据和响应数据的当前页数的key值，默认是'current'
- (nullable NSString*)lx_currentName;

///响应数据总页面个数的key值，默认是'pages'
- (nullable NSString*)lx_pagesName;

///响应分页数据实体的数组key值，默认是'records'
- (nullable NSString*)lx_onePageDataArrName;

@end


#endif /* LXNetworkConfigureProtocol_h */
