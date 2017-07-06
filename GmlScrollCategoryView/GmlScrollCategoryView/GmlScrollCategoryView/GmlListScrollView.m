//
//  GmlListScrollView.h
//  gaomaolin
//
//  Created by gaomaolin on 17-07-06.
//  Copyright (c) 2017年 gaomaolin. All rights reserved.
//

#import "GmlListScrollView.h"

@interface GmlListScrollView (){
    
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
    NSInteger _curPage;
    BOOL isUserSetContentOffsetX;
}
@end

@implementation GmlListScrollView
@synthesize curPage = _curPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
        isUserSetContentOffsetX = NO;
    }
    return self;
}

#pragma mark - property
- (NSInteger)curPage{
    _curPage = (int)(self.contentOffset.x/self.frame.size.width);
    return _curPage;
}

- (void)setChildVCArr:(NSArray *)childVCArr{
    _childVCArr = childVCArr;
    for (int i = 0; i < [_childVCArr count]; i++) {
        
        UIViewController *childVC = _childVCArr[i];
        
        childVC.view.frame = CGRectMake(0+self.frame.size.width*i,
                                        0,
                                        self.frame.size.width,
                                        self.frame.size.height);
        
        childVC.view.tag = TAG_BASE + i;
        [self addSubview:childVC.view];
    }
    self.contentSize = CGSizeMake(self.frame.size.width*_childVCArr.count,
                                  self.frame.size.height);
}

#pragma mark - public
- (void)scrollToPage:(NSInteger)page{
    //设置为-1；在 scrollViewDidScroll 不用去回调DidScrollTo
    isUserSetContentOffsetX = YES;
    
    [self setContentOffset:CGPointMake(page*[UIScreen mainScreen].bounds.size.width, 0)
                  animated:YES];
    userContentOffsetX = page*[UIScreen mainScreen].bounds.size.width;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isUserSetContentOffsetX = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
        if (!isUserSetContentOffsetX) {
            CGFloat rate = (scrollView.contentOffset.x - userContentOffsetX)/scrollView.frame.size.width;
            if ([self.delegateSelf respondsToSelector:@selector(GmlListScrollView: DidScrollTo:)]) {
                [self.delegateSelf GmlListScrollView:self DidScrollTo:rate];
            }
        }
    }
    else {
        isLeftScroll = NO;
        if (!isUserSetContentOffsetX) {
            CGFloat rate = (scrollView.contentOffset.x - userContentOffsetX)/scrollView.frame.size.width;
            if ([self.delegateSelf respondsToSelector:@selector(GmlListScrollView: DidScrollTo:)]) {
                [self.delegateSelf GmlListScrollView:self DidScrollTo:rate];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    userContentOffsetX = scrollView.contentOffset.x;
    [self adjustTopScrollViewButton:scrollView];
}
//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    _curPage = (int)(scrollView.contentOffset.x/self.frame.size.width);
    if ([self.delegateSelf respondsToSelector:@selector(GmlListScrollView:SelectedItemIndex:)]) {
        [self.delegateSelf GmlListScrollView:self SelectedItemIndex:_curPage];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
