//
//  GmlScrollCategoryView.m
//  gaomaolin
//
//  Created by gaomaolin on 17-07-06.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GmlScrollCategoryView.h"
#define IPAD_DEVICE  (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0)
@interface GmlScrollCategoryView()<UIScrollViewDelegate>{
    /*背景图片*/
    UIImageView *scrollBgView;
    /* 滚动视图 */
    UIScrollView *mScrollView;
    /* 当前分类的下划线标记 */
    UIView *moveView;
    /* 分类对应button的数组 */
    NSMutableArray *categoryBtnArrM;
    /* 左边还有更多分类的标记 */
    UIImageView *leftMoreimageView;
    /* 右边还有更多分类的标记 */
    UIImageView *rigthMoreimageView;
    /* 屏幕宽度显示的最大分类数 */
    float colNum;
}
@end

@implementation GmlScrollCategoryView

- (id)initWithFrame:(CGRect)frame CategoryArr:(NSArray*)categoryArr{
    if ([categoryArr count]==0) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if (self) {
        colNum=(IPAD_DEVICE)?12:6;
        unsigned long categoryMax = 0;
        for (int i=0; i<[categoryArr count]; i++) {
            NSString *category=[categoryArr objectAtIndex:i];
            if (category.length > categoryMax) {
                categoryMax = category.length;
            }
        }
        
        if (categoryMax > 10) {
            colNum=(IPAD_DEVICE)?4:2;
        }
        else if (categoryMax > 8) {
            colNum = (IPAD_DEVICE)?6:3;
        }
        else if (categoryMax > 4) {
            colNum = (IPAD_DEVICE)?8:4;
        }
        
        if (colNum > categoryArr.count) {
            colNum = categoryArr.count;
        }
        
        _categoryArrM=[[NSMutableArray alloc] initWithArray:categoryArr];
        categoryBtnArrM=[[NSMutableArray alloc] init];
        
        scrollBgView=[[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollBgView];
        scrollBgView.backgroundColor = [UIColor colorWithRed:245.0/256.0 green:245.0/256.0 blue:245.0/256.0 alpha:1];
        scrollBgView.userInteractionEnabled=YES;
        
        leftMoreimageView=[[UIImageView alloc] initWithFrame:CGRectMake((IPAD_DEVICE)?10:5, 0, 10, scrollBgView.frame.size.height)];
        leftMoreimageView.image=[UIImage imageNamed:@"category_left_more"];
        [scrollBgView addSubview:leftMoreimageView];
        leftMoreimageView.alpha=0;
        
        rigthMoreimageView=[[UIImageView alloc] initWithFrame:CGRectMake(scrollBgView.frame.size.width-10-((IPAD_DEVICE)?10:5), 0, 10, scrollBgView.frame.size.height)];
        rigthMoreimageView.image=[UIImage imageNamed:@"category_right_more"];
        [scrollBgView addSubview:rigthMoreimageView];
        rigthMoreimageView.alpha=1;
        
        mScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, scrollBgView.frame.size.width-24, scrollBgView.frame.size.height)];
        mScrollView.delegate=self;
        mScrollView.scrollsToTop=NO;
        mScrollView.showsHorizontalScrollIndicator=NO;
        mScrollView.contentSize=CGSizeMake(mScrollView.frame.size.width/colNum*[_categoryArrM count], mScrollView.frame.size.height);
        if (mScrollView.contentSize.width<=mScrollView.frame.size.width) {
            leftMoreimageView.alpha=0;
            rigthMoreimageView.alpha=0;
            mScrollView.frame=CGRectMake(10+(mScrollView.frame.size.width-mScrollView.contentSize.width)/2, 0, mScrollView.frame.size.width, mScrollView.frame.size.height);
        }
        [scrollBgView insertSubview:mScrollView atIndex:0];
        
        UIView *naviLine=[[UIView alloc] initWithFrame:CGRectMake(0, scrollBgView.frame.size.height-1, scrollBgView.frame.size.width, 1)];
        [scrollBgView addSubview:naviLine];
        naviLine.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        
        if ([_categoryArrM count]>0) {
            moveView=[[UIView alloc] initWithFrame:CGRectMake(mScrollView.frame.size.width/colNum*_currentPage,mScrollView.frame.size.height-3,
                                                                mScrollView.frame.size.width/colNum,2)];
            moveView.backgroundColor = [UIColor colorWithRed:0.0 green:175.0/256.0 blue:255.0/256.0 alpha:1];
            [mScrollView addSubview:moveView];
        }
        
        for (int i=0;i<[categoryBtnArrM count];i++) {
            UIButton *btn =[ categoryBtnArrM objectAtIndex:i];
            [btn removeFromSuperview];
        }
        [categoryBtnArrM removeAllObjects];
        
        for (int i=0;i<[_categoryArrM count];i++) {
            NSString *categoryStr =[_categoryArrM objectAtIndex:i];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=i;
            btn.frame=CGRectMake(mScrollView.frame.size.width/colNum*i, 0, mScrollView.frame.size.width/colNum, mScrollView.frame.size.height);
            [btn addTarget:self action:@selector(touchCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:categoryStr forState:UIControlStateNormal];
            
            btn.frame=CGRectMake(mScrollView.frame.size.width/colNum*i, 0, mScrollView.frame.size.width/colNum, mScrollView.frame.size.height);
            [btn setTitleColor:[UIColor colorWithRed:102.0/256.0 green:102.0/256.0 blue:102.0/256.0 alpha:1]  forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithRed:51.0/256.0 green:51.0/256.0 blue:51.0/256.0 alpha:1]  forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
            }
            [mScrollView addSubview:btn];
            [categoryBtnArrM addObject:btn];
        }
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
 */

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==mScrollView) {
        if (scrollView.contentOffset.x>0){
            leftMoreimageView.alpha=1;
            if (scrollView.contentOffset.x<scrollView.contentSize.width-scrollView.frame.size.width) {
                rigthMoreimageView.alpha=1;
            }
            else{
                rigthMoreimageView.alpha=0;
            }
        }
        else{
            leftMoreimageView.alpha=0;
            if (scrollView.contentOffset.x<scrollView.contentSize.width-scrollView.frame.size.width) {
                rigthMoreimageView.alpha=1;
            }
            else{
                rigthMoreimageView.alpha=0;
            }
        }
    }
}

#pragma mark - touch
-(void)touchCategoryBtn:(UIButton*)btn{
    _currentPage=btn.tag;
    for (int i=0; i<[categoryBtnArrM count]; i++) {
        UIButton *categoryBtn=[categoryBtnArrM objectAtIndex:i];
        if (i==_currentPage) {
            [UIView beginAnimations:nil context:nil];
            moveView.frame=CGRectMake(mScrollView.frame.size.width/colNum*btn.tag,mScrollView.frame.size.height-3,
                                        mScrollView.frame.size.width/colNum,3);
            if ([categoryBtnArrM count]>colNum) {
                if (moveView.frame.origin.x+2*moveView.frame.size.width>mScrollView.contentOffset.x+mScrollView.frame.size.width
                    ||mScrollView.contentOffset.x+mScrollView.frame.origin.x>moveView.frame.origin.x) {
                    float x=mScrollView.frame.size.width/colNum*i-mScrollView.frame.size.width/2;
                    if (x<0) {
                        x=0;
                    }
                    if (x>mScrollView.contentSize.width-mScrollView.frame.size.width) {
                        x=mScrollView.contentSize.width-mScrollView.frame.size.width;
                    }
                    mScrollView.contentOffset=CGPointMake(x, 0);
                }
            }
            [categoryBtn setTitleColor:[UIColor colorWithRed:51.0/256.0 green:51.0/256.0 blue:51.0/256.0 alpha:1]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [UIView commitAnimations];
        }
        else{
            categoryBtn.frame=CGRectMake(mScrollView.frame.size.width/colNum*i, 0, mScrollView.frame.size.width/colNum, mScrollView.frame.size.height);
            [categoryBtn setTitleColor:[UIColor colorWithRed:102.0/256.0 green:102.0/256.0 blue:102.0/256.0 alpha:1]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    if ([self.delegate respondsToSelector:@selector(categoryView: touchCategoryBtn:)]) {
		[self.delegate categoryView:self touchCategoryBtn:btn];
	}
}
#pragma mark - public
- (void)moveMoveView:(CGFloat)rate{
    CGFloat WIDTH_CATEGORY_BUTTON = mScrollView.frame.size.width/colNum;
    CGFloat x = WIDTH_CATEGORY_BUTTON*_currentPage;
    CGFloat w = moveView.frame.size.width;
    x = x + w * rate;
    moveView.frame = CGRectMake(x, moveView.frame.origin.y, moveView.frame.size.width, moveView.frame.size.height);
}

-(void)moveCategoryWithTitle:(NSString*)title{
    int index=0;
    for (int i=0; i<[categoryBtnArrM count]; i++) {
        UIButton *btn=[categoryBtnArrM objectAtIndex:i];
        NSString *category=[btn titleForState:UIControlStateNormal];
        if ([category isEqualToString:title]) {
            index=i;
            break;
        }
    }
    
    _currentPage=index;
    for (int i=0; i<[categoryBtnArrM count]; i++) {
        UIButton *categoryBtn=[categoryBtnArrM objectAtIndex:i];
        if (i==_currentPage) {
            moveView.frame=CGRectMake(mScrollView.frame.size.width/colNum*i,mScrollView.frame.size.height-3,
                                        mScrollView.frame.size.width/colNum,3);
            [categoryBtn setTitleColor:[UIColor colorWithRed:51.0/256.0 green:51.0/256.0 blue:51.0/256.0 alpha:1]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else{
            categoryBtn.frame=CGRectMake(mScrollView.frame.size.width/colNum*i, 0, mScrollView.frame.size.width/colNum, mScrollView.frame.size.height);
            [categoryBtn setTitleColor:[UIColor colorWithRed:102.0/256.0 green:102.0/256.0 blue:102.0/256.0 alpha:1]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
-(void)touchCategoryBtnWithTitle:(NSString*)title{
    [self moveCategoryWithTitle:title];
    [self touchCategoryBtn:[categoryBtnArrM objectAtIndex:_currentPage]];
}
@end
