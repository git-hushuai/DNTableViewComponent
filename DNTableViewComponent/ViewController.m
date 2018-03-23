//
//  ViewController.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "ViewController.h"
#import "DNBaseTableView.h"
#import "DNBottomTableViewCell.h"
#import "DNTitleComponentView.h"
#import "DNSubItemContentVC.h"
#import "DNDemoTableViewCellTWO.h"
#define kDNDemoTableViewCellTWOReUseID @"DNDemoTableViewCellTWO"
#define kDNBottomTableViewCellReUseID @"DNBottomTableViewCell"



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,DNSubVCContainerViewDelegate,DNTitleComponentViewDelegate>
@property (weak, nonatomic) IBOutlet DNBaseTableView *tableView;
@property (nonatomic ,strong) NSArray *segmentTitleArray;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic ,strong) DNBottomTableViewCell *contentCell;
@property (nonatomic ,strong) DNTitleComponentView *titleContainerView;
@property (nonatomic ,strong) DNDemoTableViewCellTWO *topContentCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initUI
{
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"DNDemoTableViewCellTWO" bundle:nil] forCellReuseIdentifier:kDNDemoTableViewCellTWOReUseID];
    [_tableView registerNib:[UINib nibWithNibName:@"DNBottomTableViewCell" bundle:nil] forCellReuseIdentifier:kDNBottomTableViewCellReUseID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSuccessAction:) name:KNOTIFICATION_RANK_REFRESH_SUCCESS_NOTI object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"TableView";
    self.segmentTitleArray = @[@"纸品类",@"洗护类",@"恢复类",@"纸品类2",@"洗护类2",@"恢复类2",@"纸品类3",@"洗护类3",@"恢复类3"];

    [self configTableView];
}

- (void)refreshSuccessAction:(id)param
{
    [self.tableView.mj_header endRefreshing];
}

#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

- (void)configTableView
{
    self.canScroll = YES;
    DNWEAKSELF
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DNSTRONGSELF
        [strongSelf refreshAction];
    }];
    self.tableView.mj_header = header;
    
    [self refreshAction];
}

- (void)refreshAction
{
    self.contentCell.currentTagStr = [self.segmentTitleArray objectAtIndex:self.titleContainerView.selectIndex];
    self.contentCell.isRefresh = YES;
}
#pragma mark UITableView 的代理和数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? 1 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 165;
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0:50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.titleContainerView = [[DNTitleComponentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)  title:self.segmentTitleArray delegate:self indicatorType:DNTitleComponentViewEqualTitle];
    self.titleContainerView.backgroundColor = [UIColor whiteColor];
    return self.titleContainerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (!_contentCell) {
            _contentCell = [tableView dequeueReusableCellWithIdentifier:kDNBottomTableViewCellReUseID];
            NSArray *titleArr = self.segmentTitleArray;
            NSMutableArray *contentVCS = [NSMutableArray array];
            int i = 0;
            for (NSString *title in titleArr) {
                DNSubItemContentVC *vc = [DNSubItemContentVC new];
                vc.title = title;
                vc.str = title;
                [contentVCS addObject:vc];
                i++;
            }
            _contentCell.viewControllers = contentVCS;
            _contentCell.pageContentView = [[DNSubVCContainerView alloc] initWithFrame:CGRectMake(0, 0, UCSScreen_Width, self.tableView.bounds.size.height-50) childVCs:contentVCS parentVC:self delegate:self];
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    if (!_topContentCell) {
        _topContentCell = [tableView dequeueReusableCellWithIdentifier:kDNDemoTableViewCellTWOReUseID];
    }
    return _topContentCell;
}

#pragma mark DNItemControllerContainerViewDelegate
- (void)DNSubVCContainerViewDidEndDecelerating:(DNSubVCContainerView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    _tableView.scrollEnabled = YES;
    NSLog(@"DNSubVCContainerViewDidEndDecelerating start:%@==end:%@",@(startIndex),@(endIndex));
    if (startIndex == endIndex) {
        return;
    }
    if (self.titleContainerView.selectIndex != endIndex) {
        self.titleContainerView.selectIndex = endIndex;
        [self refreshAction];
    }
    // 此处其实是监测scrollView滚动，pageView滚地结束主tanleView可以滑动，或者通过手势监听或者KVO，这里只是提供一种实现方式
}

- (void)DNSubVCContainerViewDidScroll:(DNSubVCContainerView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _tableView.scrollEnabled = NO; // PageView开始滚动主tableView禁止滑动
}

- (void)pageContentTitleView:(DNTitleComponentView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    NSLog(@"pageContentTitleView start:%@==end:%@",@(startIndex),@(endIndex));
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
    if (self.titleContainerView.selectIndex != endIndex) {
        self.titleContainerView.selectIndex = endIndex;
        [self refreshAction];
    }
}

#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomCellOffSet = [_tableView rectForSection:1].origin.y;
    if (scrollView.contentOffset.y >= bottomCellOffSet) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffSet);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {
            // 子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffSet);
        }
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
