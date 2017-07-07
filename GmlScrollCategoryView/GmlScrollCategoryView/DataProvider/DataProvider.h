//
//  DataProvider.h
//  GmlScrollCategoryView
//
//  Created by maolin gao on 2017/7/7.
//  Copyright © 2017年 maolin gao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCategoryMoveCollection @"过人大全"
#define kCategoryLatest         @"最近更新"
#define kCategoryMove           @"动作分类"
#define kCategoryNBA            @"NBA"

@interface DataProvider : NSObject

- (NSDictionary *)getDataWith:(NSString *)category;
@end
