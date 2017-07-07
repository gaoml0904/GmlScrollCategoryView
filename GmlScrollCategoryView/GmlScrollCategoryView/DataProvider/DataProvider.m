//
//  DataProvider.m
//  GmlScrollCategoryView
//
//  Created by maolin gao on 2017/7/7.
//  Copyright © 2017年 maolin gao. All rights reserved.
//

#import "DataProvider.h"

@implementation DataProvider

- (NSDictionary *)getDataWith:(NSString *)category {
    NSArray *categoryArr = @[];
    NSArray *bookArr = @[];
    if ([category isEqualToString:kCategoryMoveCollection]) {
        
        categoryArr = @[kCategoryLatest,kCategoryMove,kCategoryNBA];
    } else if ([category isEqualToString:kCategoryLatest]) {
        
        bookArr = @[@"保罗-转身-2",@"保罗-转身-1",@"保罗-阴沟翻船",@"背后传球6-太骚了我不敢学"];
    } else if ([category isEqualToString:kCategoryMove]) {
        
        categoryArr = @[@"交叉运球过人",@"跨下来回交叉",@"阴沟翻船",@"停顿过人",@"左跨下过人"];
    } else if ([category isEqualToString:@"交叉运球过人"]) {
        
        bookArr = @[@"交叉运球过人-1",@"交叉运球过人-2",@"交叉运球过人-3",@"交叉运球过人-4",@"交叉运球过人-5"];
    } else if ([category isEqualToString:@"跨下来回交叉"]) {
        
        bookArr = @[@"跨下来回交叉-1",@"跨下来回交叉-2",@"跨下来回交叉-3",@"跨下来回交叉-4",@"跨下来回交叉-5"];
    } else if ([category isEqualToString:@"阴沟翻船"]) {
        
        bookArr = @[@"阴沟翻船-1",@"阴沟翻船-2",@"阴沟翻船-3",@"阴沟翻船-4",@"阴沟翻船-5"];
    } else if ([category isEqualToString:@"停顿过人"]) {
        
        bookArr = @[@"停顿过人-1",@"停顿过人-2",@"停顿过人-3",@"停顿过人-4",@"停顿过人-5"];
    } else if ([category isEqualToString:@"左跨下过人"]) {
        
        bookArr = @[@"左跨下过人-1",@"左跨下过人-2",@"左跨下过人-3",@"左跨下过人-4",@"左跨下过人-5"];
    } else if ([category isEqualToString:kCategoryNBA]) {
        
        categoryArr = @[@"湖人",@"火箭",@"快船",@"勇士",@"太阳"];
    } else if ([category isEqualToString:@"湖人"]) {
        
        categoryArr = @[@"科比",@"奥利尔",@"马龙"];
    } else if ([category isEqualToString:@"火箭"]) {
        
        categoryArr = @[@"哈登",@"贝弗利",@"戈登"];
    }  else if ([category isEqualToString:@"快船"]) {
        
        categoryArr = @[@"保罗",@"格力分",@"克6"];
    } else if ([category isEqualToString:@"哈登"]) {
        
        bookArr = @[@"哈登过人-1",@"哈登过人-2",@"哈登过人-3"];
    } else if ([category isEqualToString:@"科比"]) {
        
        bookArr = @[@"科比过人-1",@"科比过人-2",@"科比过人-3"];
    } else if ([category isEqualToString:@"奥利尔"]) {
        
        bookArr = @[@"奥利尔-1",@"奥利尔-2",@"奥利尔-3"];
    } else if ([category isEqualToString:@"马龙"]) {
        
        bookArr = @[@"马龙-1",@"马龙-2",@"马龙-3"];
    }
    
    return @{@"categoryArr":categoryArr,@"bookArr":bookArr};
}
@end
