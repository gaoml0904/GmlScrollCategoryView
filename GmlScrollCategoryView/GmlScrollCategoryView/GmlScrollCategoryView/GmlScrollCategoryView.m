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
    
    UIImageView *scrollBgView;
    UIScrollView *mScrollView;
    UIView *moveView;
    NSMutableArray *categoryNewMsgViewArrM;
    NSMutableArray *categoryBtnArrM;
    UIImageView *leftMoreimageView;
    UIImageView *rigthMoreimageView;
    
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
        categoryNewMsgViewArrM=[[NSMutableArray alloc] init];
        
        scrollBgView=[[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollBgView];
        scrollBgView.backgroundColor = [UIColor colorWithHexString:@"0xf5f5f5"];
        scrollBgView.userInteractionEnabled=YES;
        
        leftMoreimageView=[[UIImageView alloc] initWithFrame:CGRectMake((IPAD_DEVICE)?10:5, 0, 10, HEIGHT(scrollBgView))];
        leftMoreimageView.image=[UIImage imageNamed:@"category_left_more"];
        [scrollBgView addSubview:leftMoreimageView];
        leftMoreimageView.alpha=0;
        
        rigthMoreimageView=[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(scrollBgView)-10-((IPAD_DEVICE)?10:5), 0, 10, HEIGHT(scrollBgView))];
        rigthMoreimageView.image=[UIImage imageNamed:@"category_right_more"];
        [scrollBgView addSubview:rigthMoreimageView];
        rigthMoreimageView.alpha=1;
        
        mScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, WIDTH(scrollBgView)-24, HEIGHT(scrollBgView))];
        mScrollView.delegate=self;
        mScrollView.scrollsToTop=NO;
        mScrollView.showsHorizontalScrollIndicator=NO;
        mScrollView.contentSize=CGSizeMake(WIDTH(mScrollView)/colNum*[_categoryArrM count], HEIGHT(mScrollView));
        if (mScrollView.contentSize.width<=WIDTH(mScrollView)) {
            leftMoreimageView.alpha=0;
            rigthMoreimageView.alpha=0;
            mScrollView.frame=CGRectMake(10+(WIDTH(mScrollView)-mScrollView.contentSize.width)/2, 0, WIDTH(mScrollView), HEIGHT(mScrollView));
        }
        [scrollBgView insertSubview:mScrollView atIndex:0];
        
        UIView *naviLine=[[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(scrollBgView)-1, WIDTH(scrollBgView), 1)];
        [scrollBgView addSubview:naviLine];
        naviLine.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        
        if ([_categoryArrM count]>0) {
            moveView=[[UIView alloc] initWithFrame:CGRectMake(WIDTH(mScrollView)/colNum*_currentPage,HEIGHT(mScrollView)-3,
                                                                WIDTH(mScrollView)/colNum,2)];
            moveView.backgroundColor = [UIColor colorWithHexString:@"0x00afff"];
            [mScrollView addSubview:moveView];
        }
        
        for (int i=0;i<[categoryBtnArrM count];i++) {
            UIButton *btn =[ categoryBtnArrM objectAtIndex:i];
            [btn removeFromSuperview];
        }
        [categoryBtnArrM removeAllObjects];
        
        for (int i=0;i<[categoryNewMsgViewArrM count];i++) {
            UIImageView *newFlagView =[ categoryNewMsgViewArrM objectAtIndex:i];
            [newFlagView removeFromSuperview];
        }
        [categoryNewMsgViewArrM removeAllObjects];
        
        for (int i=0;i<[_categoryArrM count];i++) {
            NSString *categoryStr =[_categoryArrM objectAtIndex:i];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=i;
            btn.frame=CGRectMake(WIDTH(mScrollView)/colNum*i, 0, WIDTH(mScrollView)/colNum, HEIGHT(mScrollView));
            [btn addTarget:self action:@selector(touchCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:categoryStr forState:UIControlStateNormal];
            
            btn.frame=CGRectMake(WIDTH(mScrollView)/colNum*i, 0, WIDTH(mScrollView)/colNum, HEIGHT(mScrollView));
            [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"]  forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithHexString:@"0x333333"]  forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
            }
            [mScrollView addSubview:btn];
            
            CGSize size = [categoryStr boundingRectWithSize:CGSizeMake(WIDTH(btn), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|
                                                                                                 NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : btn.titleLabel.font} context:nil].size;

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(btn)/2+size.width/2-4, HEIGHT(btn)/2-size.height/2-4, 8, 8)];
            imageView.image = [UIImage imageNamed:@"Message_has_new"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = i;
            imageView.hidden = true;
            [btn addSubview:imageView];
            
            [categoryNewMsgViewArrM addObject:imageView];
            
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
            moveView.frame=CGRectMake(WIDTH(mScrollView)/colNum*btn.tag,HEIGHT(mScrollView)-3,
                                        WIDTH(mScrollView)/colNum,3);
            if ([categoryBtnArrM count]>colNum) {
                if (X(moveView)+2*WIDTH(moveView)>mScrollView.contentOffset.x+WIDTH(mScrollView)
                    ||mScrollView.contentOffset.x+X(mScrollView)>X(moveView)) {
                    float x=WIDTH(mScrollView)/colNum*i-WIDTH(mScrollView)/2;
                    if (x<0) {
                        x=0;
                    }
                    if (x>mScrollView.contentSize.width-WIDTH(mScrollView)) {
                        x=mScrollView.contentSize.width-WIDTH(mScrollView);
                    }
                    mScrollView.contentOffset=CGPointMake(x, 0);
                }
            }
            [categoryBtn setTitleColor:[UIColor colorWithHexString:@"0x333333"]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [UIView commitAnimations];
        }
        else{
            categoryBtn.frame=CGRectMake(WIDTH(mScrollView)/colNum*i, 0, WIDTH(mScrollView)/colNum, HEIGHT(mScrollView));
            [categoryBtn setTitleColor:[UIColor colorWithHexString:@"0x666666"]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    if ([self.delegate respondsToSelector:@selector(categoryView: touchCategoryBtn:)]) {
		[self.delegate categoryView:self touchCategoryBtn:btn];
	}
}
#pragma mark - public
- (void)moveMoveView:(CGFloat)rate{
    CGFloat WIDTH_CATEGORY_BUTTON = WIDTH(mScrollView)/colNum;
    CGFloat x = WIDTH_CATEGORY_BUTTON*_currentPage;
    CGFloat w = moveView.frame.size.width;
    x = x + w * rate;
    moveView.frame = CGRectMake(x, Y(moveView), WIDTH(moveView), HEIGHT(moveView));
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
            moveView.frame=CGRectMake(WIDTH(mScrollView)/colNum*i,HEIGHT(mScrollView)-3,
                                        WIDTH(mScrollView)/colNum,3);
            [categoryBtn setTitleColor:[UIColor colorWithHexString:@"0x333333"]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else{
            categoryBtn.frame=CGRectMake(WIDTH(mScrollView)/colNum*i, 0, WIDTH(mScrollView)/colNum, HEIGHT(mScrollView));
            [categoryBtn setTitleColor:[UIColor colorWithHexString:@"0x666666"]  forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
-(void)touchCategoryBtnWithTitle:(NSString*)title{
    [self moveCategoryWithTitle:title];
    [self touchCategoryBtn:[categoryBtnArrM objectAtIndex:_currentPage]];
}

- (void)updateNewMsgFlagIconWithTitle:(NSString *)title hideState:(BOOL)isHide{
    if (title == nil || self.categoryArrM.count == 0) {
        return;
    }
    NSInteger index = [self.categoryArrM indexOfObject:title];
    if (index >= categoryNewMsgViewArrM.count) {
        return;
    }
    
    UIImageView *imgView = categoryNewMsgViewArrM[index];
    imgView.hidden = isHide;
}
@end
