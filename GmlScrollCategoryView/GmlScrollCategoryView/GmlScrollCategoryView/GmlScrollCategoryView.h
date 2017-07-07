//
//  GmlScrollCategoryView.h
//  gaomaolin
//
//  Created by li lin on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GmlScrollCategoryView;
@protocol CategoryViewDelegate<NSObject>
@optional
-(void)categoryView:(GmlScrollCategoryView*)categoryView touchCategoryBtn:(UIButton*)categoryBtn;
@end

@interface GmlScrollCategoryView : UIView

@property(nonatomic,assign)id<CategoryViewDelegate>delegate;

@property(nonatomic,retain)NSMutableArray *categoryArrM;
@property(nonatomic) NSInteger currentPage;

- (id)initWithFrame:(CGRect)frame CategoryArr:(NSArray*)categoryArr;
- (void)moveMoveView:(CGFloat)rate;
- (void)moveCategoryWithTitle:(NSString*)title;
- (void)touchCategoryBtnWithTitle:(NSString*)title;
@end
