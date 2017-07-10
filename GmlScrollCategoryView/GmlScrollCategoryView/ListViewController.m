//
//  ViewController.m
//  GmlScrollCategoryView
//
//  Created by maolin gao on 2017/7/6.
//  Copyright © 2017年 maolin gao. All rights reserved.
//

#import "ListViewController.h"
#import "GmlScrollCategoryView.h"
#import "GmlListScrollView.h"
#import "DataProvider.h"

@interface ListViewController ()<CategoryViewDelegate,GmlListScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableDictionary *dataDicM;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)GmlScrollCategoryView *categoryView;
@property(nonatomic,strong)GmlListScrollView *listScrollView;
@property(nonatomic,strong)DataProvider *dataProvider;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    _dataDicM = [[NSMutableDictionary alloc] init];
    if (self.category == nil) {
        self.category = @"过人大全";
        self.title = self.category;
        [self getCategoryData];
    }
}

- (void)getCategoryData{
    if (_dataProvider == nil) {
        _dataProvider = [[DataProvider alloc] init];
    }
    NSDictionary *dic = [_dataProvider getDataWith:self.category];
    [_dataDicM setDictionary:dic];
    [self reloadData];
}

- (void)reloadData{
    
    if ([_dataDicM objectForKey:@"categoryArr"] && ((NSArray *)[_dataDicM objectForKey:@"categoryArr"]).count>0) {
        /*还有子分类*/
        _categoryView.delegate = nil;
        [_categoryView removeFromSuperview];
        _categoryView = nil;
        NSArray *categoryArr = [_dataDicM objectForKey:@"categoryArr"];
        _categoryView = [[GmlScrollCategoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) CategoryArr:categoryArr];
        _categoryView.delegate = self;
        [self.view addSubview:_categoryView];
        
        _listScrollView.delegate = nil;
        [_listScrollView removeFromSuperview];
        _listScrollView = nil;
        _listScrollView = [[GmlListScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        _listScrollView.delegateSelf = self;
        
        NSMutableArray *childVCArrM = [[NSMutableArray alloc] init];
        for (int i = 0; i < _categoryView.categoryArrM.count; i++) {
            
            ListViewController *itemVC =[[ListViewController alloc] init];
            if (self.weakNavi) {
                itemVC.weakNavi = self.weakNavi;
            } else {
                itemVC.weakNavi = self.navigationController;
            }
            itemVC.category = _categoryView.categoryArrM[i];
            itemVC.index = i;
            itemVC.view.frame = CGRectMake(0+_listScrollView.frame.size.width*i,
                                           0,
                                           _listScrollView.frame.size.width,
                                           _listScrollView.frame.size.height);
            [_listScrollView addSubview:itemVC.view];
            
            [childVCArrM addObject:itemVC];
        }
        _listScrollView.childVCArr = childVCArrM;
        
        _listScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*[_listScrollView.childVCArr count],
                                                 _listScrollView.frame.size.height);
        [self.view insertSubview:_listScrollView atIndex:0];
        if (_listScrollView.childVCArr.count > 0) {
            ListViewController *itemVC = (ListViewController *)_listScrollView.childVCArr[0];
            [itemVC getCategoryData];
        }
    } else {
        /*没有子分类，只有一个列表*/
        [self.view addSubview:self.tableView];
        [_tableView reloadData];
    }
}


#pragma mark CategoryViewDelegate
-(void)categoryView:(GmlScrollCategoryView*)categoryView touchCategoryBtn:(UIButton*)categoryBtn {
    
    ListViewController *itemVC = _listScrollView.childVCArr[categoryView.currentPage];
    [itemVC getCategoryData];
    [_listScrollView scrollToPage:categoryView.currentPage];
}

#pragma mark GmlListScrollViewDelegate
- (void)GmlListScrollView:(GmlListScrollView *)listView SelectedItemIndex:(NSInteger)index{
    
    NSString *categoryStr = [_categoryView.categoryArrM objectAtIndex:index];
    [_categoryView touchCategoryBtnWithTitle:categoryStr];
}

- (void)GmlListScrollView:(GmlListScrollView *)listView DidScrollTo:(CGFloat)rate{
    [_categoryView moveMoveView:rate];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *bookArr = [_dataDicM objectForKey:@"bookArr"];
    return bookArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSArray *bookArr = [_dataDicM objectForKey:@"bookArr"];
    cell.textLabel.text = bookArr[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
