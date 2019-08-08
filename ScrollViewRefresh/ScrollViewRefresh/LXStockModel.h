//
//  LXStockModel.h
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/2.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXStockModel : NSObject {
    NSString* _applyTime;
}

///项目主标题
@property (nonatomic, copy) NSString* projectName;
///项目申报时间
@property (nonatomic, copy) NSString* applyTime;
///资助金额，以万为单位 存储数据以分为单位
@property (nonatomic, copy) NSString* subsidyMoney;
///资助方式 1:政策支持 2:最高N万元补贴 3:政策+最高N万元补贴
@property (nonatomic, assign) NSInteger subsidyType;
///项目级别
@property (nonatomic, copy) NSString* projectDepartment;
///组织部门名称
@property (nonatomic, copy) NSString* dataDepartmentName;
///主键
@property (nonatomic, assign) NSInteger projectId;
///匹配率,百分转化后的整数，但无百分号
@property (nonatomic, copy) NSString* matchingRate;
///项目素材路径
@property (nonatomic, copy) NSString *materialUrl;
///适用企业
@property (nonatomic, strong) NSDictionary* applyEnterprise;
///项目创建时间同发布时间
@property (nonatomic, copy) NSString* creationDate;
///热度
@property (nonatomic, assign) NSInteger searchCount;

@end

NS_ASSUME_NONNULL_END
