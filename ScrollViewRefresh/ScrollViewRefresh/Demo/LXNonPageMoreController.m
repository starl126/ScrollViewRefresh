//
//  LXNonPageMoreController.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXNonPageMoreController.h"
#import "LXNonPageSingleController.h"
#import "LXHotNovelCell.h"

@interface LXNonPageMoreController ()<LXNetworkConfigureProtocol,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<LXHotNovelModel*>* hotNovelArr;

@end

@implementation LXNonPageMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.lx_delegate = self;
    [self.view lx_requestData];
}

#pragma mark --- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotNovelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXHotNovelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"novel_cell"];
    cell.hotModel = self.hotNovelArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}

#pragma mark --- LXNetworkConfigureProtocol
- (nonnull NSString*)lx_url {
    return @"https://www.apiopen.top/novelApi";
}
- (nullable Class)lx_dataClass {
    return LXHotNovelModel.class;
}
- (void)lx_failRequestWithMessage:(nullable NSString*)msg code:(NSInteger)code url:(nonnull NSString*)url {
    NSLog(@"fail request: url=%@,code=%zd,msg=%@", url,code,msg);
}
- (void)lx_cancelTaskWithUrl:(nonnull NSString*)url {
    NSLog(@"cancel task: url=%@", url);
}
- (void)lx_successRequestData:(nullable id)responseData url:(nonnull NSString*)url {
    NSLog(@"success request: url=%@,data=%@",url,responseData);
    self.hotNovelArr = responseData;
    [self.tableView reloadData];
}

@end
