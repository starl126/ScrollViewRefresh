//
//  LXHttpService.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/1.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LXMethodOption) {
    LXMethodOptionGet = 0,
    LXMethodOptionPost = 1,
    LXMethodOptionDelete = 2,
    LXMethodOptionPut = 3,
    LXMethodOptionHead = 4,
};

typedef NS_ENUM(NSInteger, LXResStatusType) {
    ///成功
    LXResStatusTypeSuccess = 0,
    ///笼统失败
    LXResStatusTypeCommomError = -1,
    ///登录过期
    LXResStatusTypeTokenExpired = 103,
    ///网络请求超时
    LXResStatusTypeTimeOut = -1001,
    ///网络断开，失去连接
    LXResStatusTypeDisconnect = -1009,
    ///用户没有组织信息，走注册企业
    LXResStatusTypeNoCompany = 20009,
    ///有公司但该手机号码未注册未激活
    LXResStatusTypeNoRegistered = 20002,
    ///个人登录密码错误
    LXResStatusTypePwdError = 20004,
    ///个人登录密码错误次数超过后台设置
    LXResStatusTypePwdErrorExceedMax = 20006,
    ///验证码失效
    LXResStatusTypeVerifyCodeInvalid = 20110,
    ///公司名称已注册
    LXResStatusTypeCompanyRegistered = 30001,
    ///该手机号码已注册登录/忘记密码时
    LXResStatusTypeAccountRegistered = 20001,
    ///手机短信验证码过期
    LXResStatusTypeVerifyCodeExpired = 20105,
    ///二维码已失效
    LXResStatusTypeQRcodeInvalid = 20214,
    ///其他错误状态
    LXResStatusTypeOtherErrorState,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXResponseModel : NSObject

///请求状态码：包括应用层码和网络层码
@property (nonatomic, readonly) LXResStatusType code;
///实体数据
@property (nonatomic, readonly) id data;
///服务器数据返回说明
@property (nonatomic, readonly) NSString* msg;
///该响应对应的网络请求地址
@property (nonatomic, readonly) NSString* urlStr;

@end

@interface LXHttpService : NSObject

+ (instancetype)shared;

- (void)post:(NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion;
- (void)get: (NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion;
- (void)head:(NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion;
- (void)put: (NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion;
- (void)del: (NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion;

@end

NS_ASSUME_NONNULL_END
