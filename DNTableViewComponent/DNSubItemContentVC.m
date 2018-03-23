//
//  DNSubItemContentVC.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "DNSubItemContentVC.h"
#import "DNDemoTableViewCell.h"
#define KDNDemoTableViewCellReUseIID @"DNDemoTableViewCell"
@interface DNSubItemContentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataLists;
@end

@implementation DNSubItemContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

#pragma mark Setter
- (void)setIsRefresh:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
    [self.tableView.mj_footer resetNoMoreData];
    [self refreshAction];
}

/**
 刷新网页界面
 */
- (void)refreshAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataLists addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_RANK_REFRESH_SUCCESS_NOTI object:nil];
        [self.tableView reloadData];
    });
}

- (void)resetTableViewOffSet
{
    self.tableView.contentOffset = CGPointZero;
}

- (void)initUI
{
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = DNRGBA(0xee, 0xee, 0xee, 1.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerNib:[UINib nibWithNibName:@"DNDemoTableViewCell" bundle:nil] forCellReuseIdentifier:KDNDemoTableViewCellReUseIID];
    DNWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            DNSTRONGSELF
            // 网络交互
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dataLists addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];
                  [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_RANK_REFRESH_SUCCESS_NOTI object:nil];
                [strongSelf.tableView.mj_footer endRefreshing];
                [strongSelf.tableView reloadData];
            });
        }];
        [footer setTitle:@"没有更多数据" forState:5];
        [footer setAutomaticallyHidden:YES];
        self.tableView.mj_footer = footer;
    });
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataLists.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KDNDemoTableViewCellReUseIID];
    cell.backgroundColor = [DNSubItemContentVC randomColor];
    return cell;
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        //                if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //                    return;
        //                }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}

//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (NSMutableArray *)dataLists
{
    if (!_dataLists) {
        _dataLists = [NSMutableArray array];
    }
    return _dataLists;
}

+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
