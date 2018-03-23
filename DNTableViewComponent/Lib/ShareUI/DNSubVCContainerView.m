//
//  DNSubVCContainerView.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "DNSubVCContainerView.h"

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
static NSString *collectionCellIdentifier = @"collectionCellIdentifier";

@interface DNSubVCContainerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, weak) UIViewController *parentVC;//父视图
@property (nonatomic, strong) NSArray *childsVCs;//子视图数组
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) BOOL isSelectBtn;//是否是滑动

@end

@implementation DNSubVCContainerView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<DNSubVCContainerViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        
        self.parentVC = parentVC;
        self.childsVCs = childVCs;
        self.delegate = delegate;
        
        [self setupSubViews];
    }
    return self;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

- (void)setupSubViews
{
    _startOffsetX = 0;
    _isSelectBtn  = NO;
    _contentViewCanScroll = YES;
    for (UIViewController *childVC in self.childsVCs) {
        [self.parentVC addChildViewController:childVC];
    }
    [self.collectionView reloadData];
}


#pragma mark UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childsVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (IOS_VERSION < 8.0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIViewController *childVC = self.childsVCs[indexPath.item];
        childVC.view.frame = cell.contentView.bounds;
        childVC.view.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:childVC.view];
    }
    return cell;
}

#ifdef __IPHONE_8_0
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = self.childsVCs[indexPath.row];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
}
#endif

#pragma mark UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isSelectBtn = NO;
    _startOffsetX = scrollView.contentOffset.x;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DNSubVCContainerViewWillBeginDraggng:)]) {
        [self.delegate DNSubVCContainerViewWillBeginDraggng:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isSelectBtn) {
        return;
    }
    
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex;
    CGFloat progress;
    if (currentOffsetX > _startOffsetX) {//左滑left
        progress = (currentOffsetX - _startOffsetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsVCs.count - 1) {
            endIndex = self.childsVCs.count - 1;
        }
    }else if (currentOffsetX == _startOffsetX){//没滑过去
        progress = 0;
        endIndex = startIndex;
    }else{//右滑right
        progress = (_startOffsetX - currentOffsetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0?0:endIndex;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DNSubVCContainerViewDidScroll:startIndex:endIndex:progress:)]) {
        [self.delegate DNSubVCContainerViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex = floor(currentOffsetX/scrollView_W);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DNSubVCContainerViewDidEndDecelerating:startIndex:endIndex:)]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DNSubVCContainerViewDidEndDecelerating:startIndex:endIndex:)]) {
            [self.delegate DNSubVCContainerViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
        }
    }
}

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex
{
    if (_contentViewCurrentIndex < 0 || _contentViewCurrentIndex > self.childsVCs.count - 1) {
        return;
    }
    _isSelectBtn = YES;
    _contentViewCurrentIndex = contentViewCurrentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setContentViewCanScroll:(BOOL)contentViewCanScroll
{
    _contentViewCanScroll = contentViewCanScroll;
    _collectionView.scrollEnabled = _contentViewCanScroll;
}

@end
