//
//  LXPageSingleController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXPageSingleController.h"

@interface LXPageSingleController ()<LXNetworkConfigureProtocol>

@end

@implementation LXPageSingleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.lx_delegate = self;
    [self.view lx_requestData];
}

#pragma mark --- LXNetworkConfigureProtocol
- (nonnull NSString*)lx_url {
    return @"https://api.apiopen.top/videoHomeTab";
}
- (BOOL)lx_isPageData {
    return YES;
}
- (LXMethodOption)lx_methodOption {
    return LXMethodOptionGet;
}
- (void)lx_successRequestCurrentPageData:(nullable NSArray*)curArr totalData:(nullable NSArray*)totalArr url:(nonnull NSString*)url {
    NSLog(@"success request: url=%@,curArr=%@",url,curArr);
}
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(nonnull NSString*)url {
    NSLog(@"fail request: url=%@,code=%zd,msg=%@", url,code,msg);
}
- (void)lx_cancelTaskWithUrl:(nonnull NSString*)url {
    NSLog(@"cancel task: url=%@",url);
}

@end
