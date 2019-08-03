//
//  UIView+Network.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "UIView+Network.h"
#import "UIScrollView+LXRefresh.h"

#define LXScrollSelf UIScrollView* scrollSelf = (UIScrollView*)self
#define LXScrollWeakSelf __weak typeof(UIScrollView*) lx_scrollWeakSelf = (UIScrollView*)self
#define LXWeakSelf __weak typeof(self) lx_weakSelf = self

@interface LXTaskManagerModel : NSObject

@property (nonatomic, readonly) NSString* url;
@property (nonatomic,   assign) NSUInteger latestIdentifier;
@property (nonatomic, readonly) NSMutableArray<NSURLSessionDataTask*>* taskArrM;

- (instancetype)initWithUrl:(NSString*)url identifier:(NSUInteger)identifier taskArr:(NSArray*)taskArr;

@end

@implementation LXTaskManagerModel

- (instancetype)initWithUrl:(NSString*)url identifier:(NSUInteger)identifier taskArr:(NSArray*)taskArr {
    if (self = [super init]) {
        _url = url.copy;
        _latestIdentifier = identifier;
        _taskArrM = [NSMutableArray arrayWithArray:taskArr];
    }
    return self;
}

@end

@interface UIView ()

///当前页
@property (nonatomic, assign) NSInteger lx_current;
///总页数
@property (nonatomic, assign) NSInteger lx_total;
///前一次请求的页数
@property (nonatomic, assign) NSInteger lx_previous;

@property (nonatomic, weak) MJRefreshBackNormalFooter* lx_footer;
@property (nonatomic, weak) MJRefreshStateHeader* lx_header;

@property (nonatomic, strong) AFHTTPSessionManager* manager;

///缓存请求任务task
@property (nonatomic, strong) NSMutableArray<LXTaskManagerModel*>* lx_taskArrM;
///解析数据类型缓存，用于多接口类型校正
@property (nonatomic, strong) NSMutableDictionary* lx_dataClassDictM;
///缓存分页数据，用于多接口分页校正
@property (nonatomic, strong) NSMutableDictionary* lx_isPageDictM;

@end

@implementation UIView (Network)

#pragma mark --- 处理刷新
- (void)lx_actionForDealWithRefresh {
    if (![self isKindOfClass:UIScrollView.class]) {
        return;
    }
    if ([self.lx_delegate respondsToSelector:@selector(lx_refreshOption)]) {
        LXRefreshOption opt = [self.lx_delegate lx_refreshOption];
        LXScrollSelf;
        LXWeakSelf;
        
        switch (opt) {
            case LXRefreshOptionHeader:
            {
                MJRefreshStateHeader* header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullDownRefresh];
                }];
                scrollSelf.mj_header = header;
                scrollSelf.lx_header = header;
            }
                break;
            case LXRefreshOptionFooter:
            {
                MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullUpRefresh];
                }];
                footer.stateLabel.hidden = YES;
                [footer endRefreshingWithNoMoreData];
                scrollSelf.mj_footer = footer;
                scrollSelf.lx_footer = footer;
            }
                break;
            case LXRefreshOptionHeaderFooter:
            {
                MJRefreshStateHeader* header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullDownRefresh];
                }];
                scrollSelf.mj_header = header;
                scrollSelf.lx_header = header;
                MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullUpRefresh];
                }];
                footer.stateLabel.hidden = YES;
                [footer endRefreshingWithNoMoreData];
                scrollSelf.mj_footer = footer;
                scrollSelf.lx_footer = footer;
            }
                break;
            default:
                break;
        }
    }
}
///下拉刷新
- (void)lx_actionForPullDownRefresh {
    LXScrollSelf;
    if (scrollSelf.mj_footer.isRefreshing) {
        [scrollSelf.mj_footer endRefreshing];
        [scrollSelf.mj_footer resetNoMoreData];
    }
    scrollSelf.lx_current = 1;
    [scrollSelf lx_actionForStartRequestData];
}
///上拉加载更多
- (void)lx_actionForPullUpRefresh {
    LXScrollSelf;
    if (scrollSelf.mj_header.isRefreshing) {
        [scrollSelf.mj_footer endRefreshing];
        [scrollSelf.mj_footer resetNoMoreData];
        return;
    }
    if (scrollSelf.lx_current >= self.lx_total) {
        [scrollSelf.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    scrollSelf.lx_current++;
    [scrollSelf lx_actionForStartRequestData];
}
- (void)lx_actionForStartRequestData {
    
    LXMethodOption method = [self lx_method];
    NSString* url = [self lx_checkedUrl];
    [self lx_cacheIsPageWithUrl:url];
    id parameter = [self lx_checkedParameter];
    
    LXWeakSelf;
    switch (method) {
        case LXMethodOptionGet:
        {
            NSURLSessionDataTask* task = [self.manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [lx_weakSelf lx_dealWithResponseTask:task error:error];
            }];
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionPost:
        {
            NSURLSessionDataTask* task = [self.manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [lx_weakSelf lx_dealWithResponseTask:task error:error];
            }];
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionPut:
        {
            NSURLSessionDataTask* task = [self.manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionDelete:
        {
            NSURLSessionDataTask* task = [self.manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        default:
            break;
    }
}
- (void)lx_sessionManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 20;
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        securityPolicy.allowInvalidCertificates = NO;
        self.manager.securityPolicy = securityPolicy;
        
        [self.manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            
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
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg",nil];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self.manager.requestSerializer setValue:@"2383008733b63a519e9ff7efcbc28960.3LqIwOst17" forHTTPHeaderField:@"signature"];
        NSString* token = @"eyJhbGciOiJIUzUxMiIsInppcCI6IkRFRiJ9.eNpkzkkOwjAMheG7eN1IcexETm_AMTI0IogO0FZiEHcn6oINW-vT__yGuq7Qw62-zjWHGTqoYYMerWNnmRA7CHtuAkUTMYnWtqHLVtutkKTCYVAps1bMJikRiUqblErGYNjGhofHchQdiTmK6x7_ilMsv1n0DS3XsJX5PkKvO0jzuITpeWqfiBjUFsU7suS9k88XAAD__w.PeiOwtUlVNZYy4Z9e4XwBRs9VYDJzJRYy58ksyV-WRa1_SZQfdCxTObSFPzooM4gaNpmpeQbZuieDPk7ZFQ0kQ";
        [self.manager.requestSerializer setValue:token forHTTPHeaderField:@"accessToken"];
    });
}

#pragma mark --- private
///是否分页
- (BOOL)lx_isPageList {
    if (![self isKindOfClass:UIScrollView.class]) {
        return NO;
    }
    
    BOOL isPageList = NO;
    if ([self.lx_delegate respondsToSelector:@selector(lx_isPageData)]) {
        isPageList = [self.lx_delegate lx_isPageData];
    }
    return isPageList;
}
///校正后的url请求地址
- (nullable NSString*)lx_checkedUrl {
    NSString* url = nil;
    if ([self.lx_delegate respondsToSelector:@selector(lx_url)]) {
        NSString* oriStr = [self.lx_delegate lx_url];
        url = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (CFStringRef)oriStr,
                                                                          (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                          NULL,
                                                                          kCFStringEncodingUTF8);
    }
    return url;
}
///参数校正
- (nullable id)lx_checkedParameter {
    id parameter = nil;
    if ([self.lx_delegate respondsToSelector:@selector(lx_parameters)]) {
        parameter = [self.lx_delegate lx_parameters];
    }
    if ([self lx_isPageList]) {
        //请求分页数据
        if ([parameter isKindOfClass:NSDictionary.class]) {
            parameter = [NSMutableDictionary dictionaryWithDictionary:parameter];
            NSString* pageSizeName = @"pageSize";
            NSInteger pageSize = 10;
            NSString* currentName = @"current";
            if ([self.lx_delegate respondsToSelector:@selector(lx_pageSizeName)]) {
                pageSizeName = [self.lx_delegate lx_pageSizeName];
            }
            if ([self.lx_delegate respondsToSelector:@selector(lx_pageSize)]) {
                pageSize = [self.lx_delegate lx_pageSize];
            }
            if ([self.lx_delegate respondsToSelector:@selector(lx_currentName)]) {
                currentName = [self.lx_delegate lx_currentName];
            }
            [parameter setObject:@(pageSize) forKey:pageSizeName];
            [parameter setObject:@(self.lx_current) forKey:currentName];
            //临时加入请求参数currentPage，兼容接口，后续2个版本后会删除，使用current
            [parameter setObject:@(self.lx_current) forKey:@"currentPage"];
        }
    }
    return parameter;
}
///设置请求头
- (void)lx_setRequestHeaderFiled {
    NSDictionary* dict = nil;
    if ([self.lx_delegate respondsToSelector:@selector(lx_requestHeaderFiled)]) {
        dict = [self.lx_delegate lx_requestHeaderFiled];
    }
    if (dict && dict.count) {
        for (NSString* key in dict.allKeys) {
            id value = [dict objectForKey:key];
            [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}
///获取当前页key
- (NSString*)lx_currentName {
    NSString* name = @"current";
    if ([self.lx_delegate respondsToSelector:@selector(lx_currentName)]) {
        name = [self.lx_delegate lx_currentName];
    }
    return name;
}
///获取总页数key
- (NSString*)lx_totalPagesName {
    NSString* name = @"pages";
    if ([self.lx_delegate respondsToSelector:@selector(lx_pagesName)]) {
        name = [self.lx_delegate lx_pagesName];
    }
    return name;
}
///分页数据key
- (NSString*)lx_dataArrName {
    NSString* name = @"records";
    if ([self.lx_delegate respondsToSelector:@selector(lx_onePageDataArrName)]) {
        name = [self.lx_delegate lx_onePageDataArrName];
    }
    return name;
}
///获取当前的请求method
- (LXMethodOption)lx_method {
    LXMethodOption method = LXMethodOptionPost;
    if ([self.lx_delegate respondsToSelector:@selector(lx_methodOption)]) {
        method = [self.lx_delegate lx_methodOption];
    }
    return method;
}
///判断当前请求是否是有效的最新的请求
- (BOOL)lx_isLatestRequestWithUrl:(NSString*)url taskIdentifier:(NSUInteger)taskIdentifier {
    LXTaskManagerModel* model = nil;
    for (LXTaskManagerModel* one in self.lx_taskArrM) {
        if ([one.url isEqualToString:url]) {
            model = one;
            break;
        }
    }
    if (model && model.latestIdentifier != taskIdentifier) {//无效的
        return NO;
    }else {
        return YES;
    }
}
///缓存task处理
- (void)lx_cacheTask:(NSURLSessionDataTask*)task url:(NSString*)url  {
    LXTaskManagerModel* existModel = nil;
    __weak typeof(self) lx_weakSelf = self;
    
    for (LXTaskManagerModel* model in self.lx_taskArrM) {
        if ([model.url isEqualToString:url]) {
            model.latestIdentifier = task.taskIdentifier;
            
            BOOL needCancelTaskAction = NO;
            if ([lx_weakSelf.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
                needCancelTaskAction = YES;
            }
            [model.taskArrM enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj cancel];
                if (needCancelTaskAction) {
                    [lx_weakSelf.lx_delegate lx_cancelTaskWithUrl:url];
                }
            }];
            [model.taskArrM removeAllObjects];
            existModel = model;
            break;
        }
    }
    if (existModel) {
        NSLog(@"count=%tu",existModel.taskArrM.count);
        [existModel.taskArrM addObject:task];
    }else {
        NSLog(@"count=%tu",existModel.taskArrM.count);
        LXTaskManagerModel* taskModel = [[LXTaskManagerModel alloc] initWithUrl:url identifier:task.taskIdentifier taskArr:@[task]];
        [self.lx_taskArrM addObject:taskModel];
    }
}
///缓存数据类型
- (void)lx_cacheDataClassWithUrl:(NSString*)url {
    Class cls = nil;
    if ([self.lx_delegate respondsToSelector:@selector(lx_dataClass)]) {
        cls = [self.lx_delegate lx_dataClass];
    }
    if (cls) {
        [self.lx_dataClassDictM setObject:cls forKey:url];
    }else {
        [self.lx_dataClassDictM removeObjectForKey:url];
    }
}
///缓存是否是分页
- (void)lx_cacheIsPageWithUrl:(NSString*)url {
    if (![self isKindOfClass:UIScrollView.class]) {
        [self.lx_isPageDictM setObject:@(NO) forKey:url];
        return;
    }
    BOOL isPage = NO;
    if ([self.lx_delegate respondsToSelector:@selector(lx_isPageData)]) {
        isPage = [self.lx_delegate lx_isPageData];
    }
    [self.lx_isPageDictM setObject:@(isPage) forKey:url];
}
///请求成功网络数据处理
- (void)lx_dealWithResponseDataTask:(NSURLSessionDataTask*)task responseObject:(id)responseObject {
    NSString* url = task.response.URL.absoluteString;
    
    BOOL valid = [self lx_isLatestRequestWithUrl:url taskIdentifier:task.taskIdentifier];
    if (!valid) {
        if ([self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        NSLog(@"无效identifier=%tu",task.taskIdentifier);
        return;
    }
    
    if (responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString* msg  = responseObject[@"msg"];
        id data = responseObject[@"data"];
        if (code != 0) {
            self.lx_current = self.lx_previous;
            [self.lx_header endRefreshing];
            [self.lx_footer endRefreshing];
            
            if ([self.lx_delegate respondsToSelector:@selector(lx_failRequestWithMessage:code:url:)]) {
                [self.lx_delegate lx_failRequestWithMessage:msg code:code url:url];
            }
            return ;
        }
        BOOL isPageList = [[self.lx_isPageDictM objectForKey:url] boolValue];
        if (isPageList) {//分页数据处理
            NSInteger current = [[data objectForKey:[self lx_currentName]] integerValue];
            NSInteger pages = [[data objectForKey:[self lx_totalPagesName]] integerValue];
            self.lx_total = pages;
            
            NSArray* arr = [data objectForKey:[self lx_dataArrName]];
            //解析数据
            Class cls = [self.lx_dataClassDictM objectForKey:url];
            
            if (cls) {
                NSArray* models = [NSArray yy_modelArrayWithClass:cls json:arr];
                
                if (self.lx_header.isRefreshing) {
                    [self.lx_dataSourceArrM setArray:models];
                }else {
                    [self.lx_dataSourceArrM addObjectsFromArray:models];
                }
                if ([self.lx_delegate respondsToSelector:@selector(lx_successRequestCurrentPageData:totalData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestCurrentPageData:models totalData:self.lx_dataSourceArrM.copy url:url];
                }
            }else {
                if (self.lx_header.isRefreshing) {
                    [self.lx_dataSourceArrM setArray:arr];
                }else {
                    [self.lx_dataSourceArrM addObjectsFromArray:arr];
                }
                if ([self.lx_delegate respondsToSelector:@selector(lx_successRequestCurrentPageData:totalData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestCurrentPageData:arr totalData:self.lx_dataSourceArrM.copy url:url];
                }
            }
            self.lx_current = current;
            self.lx_total = pages;
            self.lx_previous = self.lx_current;
            
            self.lx_footer.stateLabel.hidden = NO;
            if (current >= pages) {
                [self.lx_footer endRefreshingWithNoMoreData];
                [self.lx_header endRefreshing];
            }else {
                [self.lx_footer endRefreshing];
                [self.lx_footer resetNoMoreData];
                [self.lx_header endRefreshing];
            }
        }else {//非分页数据
            if (self.lx_header != nil) {
                [self.lx_header endRefreshing];
            }
            
            //解析数据
            Class cls = [self.lx_dataClassDictM objectForKey:url];
            if (cls) {
                id model = nil;
                if ([data isKindOfClass:NSArray.class]) {
                    model = [NSArray yy_modelArrayWithClass:cls json:data];
                }else {
                    model = [cls yy_modelWithJSON:data];
                }
                
                if ([self.lx_delegate respondsToSelector:@selector(lx_successRequestData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestData:model url:url];
                }
            }else {
                if ([self.lx_delegate respondsToSelector:@selector(lx_successRequestData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestData:data url:url];
                }
            }
        }
    }
}
///网络链接错误
- (void)lx_dealWithResponseTask:(NSURLSessionDataTask*)task error:(NSError*)error {
    if (self.lx_header != nil) {
        [self.lx_header endRefreshing];
    }
    if (self.lx_footer != nil) {
        [self.lx_footer endRefreshing];
    }
    self.lx_current = self.lx_previous;
    
    NSString* url = task.originalRequest.URL.absoluteString;
    //判断是否是主动cancel的任务
    if (error.code == -999 || [error.localizedDescription isEqualToString:@"cancelled"]) {
        //        NSLog(@"取消task导致的无效identifier=%tu",task.taskIdentifier);
        if ([self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        return;
    }
    BOOL valid = [self lx_isLatestRequestWithUrl:task.response.URL.absoluteString taskIdentifier:task.taskIdentifier];
    if (!valid) {
        if ([self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        //        NSLog(@"无效identifier=%tu",task.taskIdentifier);
        return;
    }
    
    if ([self.lx_delegate respondsToSelector:@selector(lx_failRequestWithMessage:code:url:)]) {
        [self.lx_delegate lx_failRequestWithMessage:error.localizedDescription code:error.code url:url];
    }
}
///初始化数据
- (void)lx_initConfigure {
    self.lx_current = 1;
    self.lx_previous = 1;
    self.lx_taskArrM = [NSMutableArray array];
    self.lx_dataClassDictM = [NSMutableDictionary dictionary];
    self.lx_dataSourceArrM = [NSMutableArray array];
    self.lx_isPageDictM    = [NSMutableDictionary dictionary];
}

#pragma mark --- public
- (void)lx_requestData {
    [self lx_actionForStartRequestData];
}
#pragma mark --- 属性设置
- (void)setLx_delegate:(id<LXNetworkConfigureProtocol>)lx_delegate {
    objc_setAssociatedObject(self, _cmd, lx_delegate, OBJC_ASSOCIATION_ASSIGN);
    if (lx_delegate) {
        //设置会话管理器
        [self lx_sessionManager];
        //设置请求头
        [self lx_setRequestHeaderFiled];
        //设置数据刷新类型
        [self lx_actionForDealWithRefresh];
        //初始化数据
        [self lx_initConfigure];
    }
}
- (id<LXNetworkConfigureProtocol>)lx_delegate {
    return objc_getAssociatedObject(self, @selector(setLx_delegate:));
}
- (void)setLx_dataSourceArrM:(NSMutableArray * _Nonnull)lx_dataSourceArrM {
    objc_setAssociatedObject(self, _cmd, lx_dataSourceArrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)lx_dataSourceArrM {
    return objc_getAssociatedObject(self, @selector(setLx_dataSourceArrM:));
}
- (void)setLx_current:(NSInteger)lx_current {
    objc_setAssociatedObject(self, _cmd, @(lx_current), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_current {
    return [objc_getAssociatedObject(self, @selector(setLx_current:)) integerValue];
}
- (void)setLx_total:(NSInteger)lx_total {
    objc_setAssociatedObject(self, _cmd, @(lx_total), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_total {
    return [objc_getAssociatedObject(self, @selector(setLx_total:)) integerValue];
}
- (void)setLx_previous:(NSInteger)lx_previous {
    objc_setAssociatedObject(self, _cmd, @(lx_previous), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_previous {
    return [objc_getAssociatedObject(self, @selector(setLx_previous:)) integerValue];
}
- (void)setManager:(AFHTTPSessionManager *)manager {
    objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFHTTPSessionManager *)manager {
    return objc_getAssociatedObject(self, @selector(setManager:));
}
- (void)setTaskIdentifier:(NSInteger)taskIdentifier {
    objc_setAssociatedObject(self, _cmd, @(taskIdentifier), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)taskIdentifier {
    return [objc_getAssociatedObject(self, @selector(setTaskIdentifier:)) integerValue];
}
- (void)setLx_footer:(MJRefreshBackNormalFooter *)lx_footer {
    objc_setAssociatedObject(self, _cmd, lx_footer, OBJC_ASSOCIATION_ASSIGN);
}
- (MJRefreshBackNormalFooter *)lx_footer {
    return objc_getAssociatedObject(self, @selector(setLx_footer:));
}
- (void)setLx_header:(MJRefreshStateHeader *)lx_header {
    objc_setAssociatedObject(self, _cmd, lx_header, OBJC_ASSOCIATION_ASSIGN);
}
- (MJRefreshStateHeader *)lx_header {
    return objc_getAssociatedObject(self, @selector(setLx_header:));
}
- (void)setLx_taskArrM:(NSMutableArray<LXTaskManagerModel *> *)lx_taskArrM {
    objc_setAssociatedObject(self, _cmd, lx_taskArrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray<LXTaskManagerModel *> *)lx_taskArrM {
    return objc_getAssociatedObject(self, @selector(setLx_taskArrM:));
}
- (void)setLx_dataClassDictM:(NSMutableDictionary *)lx_dataClassDictM {
    objc_setAssociatedObject(self, _cmd, lx_dataClassDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)lx_dataClassDictM {
    return objc_getAssociatedObject(self, @selector(setLx_dataClassDictM:));
}
- (void)setLx_isPageDictM:(NSMutableDictionary *)lx_isPageDictM {
    objc_setAssociatedObject(self, _cmd, lx_isPageDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)lx_isPageDictM {
    return objc_getAssociatedObject(self, @selector(setLx_isPageDictM:));
}

@end
