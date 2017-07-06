//
//  GmlListScrollView.h
//  gaomaolin
//
//  Created by gaomaolin on 17-07-06.
//  Copyright (c) 2017年 gaomaolin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TAG_BASE                                        1000
@class GmlListScrollView;
@protocol GmlListScrollViewDelegate <NSObject>

- (void)GmlListScrollView:(GmlListScrollView *)listView SelectedItemIndex:(NSInteger)index;
- (void)GmlListScrollView:(GmlListScrollView *)listView DidScrollTo:(CGFloat)rate;
@end

@interface GmlListScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,weak) id<GmlListScrollViewDelegate> delegateSelf;
@property (nonatomic,strong) NSArray *childVCArr;
@property (nonatomic,readonly) NSInteger curPage;
- (void)scrollToPage:(NSInteger)page;
@end
