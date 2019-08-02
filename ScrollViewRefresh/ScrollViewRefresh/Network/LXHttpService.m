//
//  LXHttpService.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/1.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXHttpService.h"

@implementation LXResponseModel


@end

@interface LXHttpService ()

@property (nonatomic, strong) AFHTTPSessionManager* manager;
@property (nonatomic, strong) NSMutableDictionary* requestCacheDictM;

@end

@implementation LXHttpService

+ (instancetype)shared {
    static LXHttpService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [LXHttpService new];
    });
    return service;
}
- (void)post:(NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion {
    NSURLSessionDataTask* task = [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [self.requestCacheDictM setObject:@(task.taskIdentifier) forKey:urlString];
}
- (void)get:(NSString*)urlString parameters:(id)parameters completion:(void (^)(LXResponseModel* data))completion {
    NSURLSessionDataTask* task = [self.manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
        
    }];
    [self.requestCacheDictM setObject:@(task.taskIdentifier) forKey:urlString];
}
#pragma mark --- lazy
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 20;
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        securityPolicy.allowInvalidCertificates = NO;
        _manager.securityPolicy = securityPolicy;
        
        [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __block NSURLCredential *cred = nil;
            
            // 判断服务器返回的证书是否是服务器信任的
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                
                cred = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (cred) {
                    disposition = NSURLSessionAuthChallengeUseCredential; //使用证书
                }
                else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling; // 忽略证书 默认的做法
                }
            }else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge; // 取消请求,忽略证书
            }
            return disposition;
            
        }];
        
        /*
         NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];
         NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
         AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate
         withPinnedCertificates:[NSSet setWithObjects:cerData, nil]];
         // 是否允许自己建立的证书有效
         securityPolicy.allowInvalidCertificates = YES;
         // 是否设置证书上的域名和客户端请求的域名有效才能请求成功，一般证书上的域名和客户端域名是相对独立的
         securityPolicy.validatesDomainName = NO;
         _sessionManager.securityPolicy = securityPolicy;
         */
        // set responseSerializer's types
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg",nil];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _manager;
}
- (NSMutableDictionary *)requestCacheDictM {
    if (!_requestCacheDictM) {
        _requestCacheDictM = [NSMutableDictionary dictionary];
    }
    return _requestCacheDictM;
}

@end
