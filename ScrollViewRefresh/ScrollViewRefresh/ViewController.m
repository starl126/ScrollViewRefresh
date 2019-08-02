//
//  ViewController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/7/23.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "ViewController.h"
#import "Library/UIScrollView+LXRefresh.h"
#import "LXStockModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,LXNetworkConfigureProtocol>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) NSUInteger type;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 200, 300, 300) style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.tableView];
    self.tableView.lx_delegate = self;
//    [self.tableView lx_requestData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (int i=0; i<40; i++) {
        self.type = i%2;
        [self.tableView lx_requestData];
    }
}
#pragma mark --- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"index---%tu", indexPath.row];
    return cell;
}

#pragma mark --- LXNetworkConfigureProtocol
- (NSString*)lx_url {
    if (self.type) {
        return @"http://app-test.qizhidao.com/qzd-bff-app/qzd/v1/policy/project/permit/declare/search";
    }else {
        return @"http://app-test.qizhidao.com/qzd-bff-app/qzd/v1/policy/project/permit/suitYou/search";
    }
}
- (LXMethodOption)lx_methodOption {
    return LXMethodOptionPost;
}
- (id)lx_parameters {
    if (self.type) {
        return @{
                 @"provinceCode": @"440000",
                 @"cityCode": @"440300"
                 };
    }else {
        return @{
                 @"provinceCode": @"440000",
                 @"cityCode": @"440300",
                 };
    }
}
- (nullable Class)lx_dataClass {
    if (self.type) {
        return LXStockModel.class;
    }else {
        return nil;
    }
}
- (LXRefreshOption)lx_refreshOption {
    return LXRefreshOptionHeaderFooter;
}
- (BOOL)lx_isPageData {
    if (self.type) {
        return YES;
    }else {
        return NO;
    }
}
- (nullable NSString*)lx_currentName {
    return @"current";
}
- (void)lx_successRequestData:(nullable id)responseData url:(NSString*)url {
//    NSLog(@"11111---%@---%@", responseData,url);
}
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(NSString*)url {
//    NSLog(@"22222---%@---%tu---%@",msg,code,url);
}
- (void)lx_successRequestCurrentPageData:(nullable NSArray*)curArr totalData:(nullable NSArray*)totalArr url:(nonnull NSString*)url {
//    NSLog(@"11111---%@---%@---%@", curArr,totalArr,url);
}

@end
