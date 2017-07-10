//
//  ListViewController.h
//  GmlScrollCategoryView
//
//  Created by maolin gao on 2017/7/6.
//  Copyright © 2017年 maolin gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController

@property(nonatomic,weak)UINavigationController *weakNavi;
@property(nonatomic,copy)NSString *category;
@property(nonatomic,assign)NSInteger index;
-(void)getCategoryData;
@end

