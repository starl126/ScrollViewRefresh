//
//  LXNewsModel.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/9.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXNewsModel.h"

@implementation LXAutoNewsModel


@end

@implementation LXNewsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"autoArr": @"auto",
             @"dyArr": @"dy",
             @"entArr": @"ent",
             @"moneyArr": @"money",
             @"sportsArr": @"sports",
             @"techArr": @"tech",
             @"toutiaoArr": @"toutiao",
             @"warArr": @"war",
             };
}
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"autoArr": LXAutoNewsModel.class,
             @"dyArr": LXAutoNewsModel.class,
             @"entArr": LXAutoNewsModel.class,
             @"moneyArr": LXAutoNewsModel.class,
             @"sportsArr": LXAutoNewsModel.class,
             @"techArr": LXAutoNewsModel.class,
             @"toutiaoArr": LXAutoNewsModel.class,
             @"warArr": LXAutoNewsModel.class,
             };
}

@end
