//
//  DNTitleComponentView.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "DNTitleComponentView.h"

#define kBtnTagConfigValue 666
@interface DNTitleComponentView()
// 添加按钮容器
@property (nonatomic ,strong) UIScrollView *scrollView;
// 按钮数组
@property (nonatomic ,strong) NSMutableArray<UIButton *> *itemBtnArray;
// 底部指示View
@property (nonatomic ,strong) UIView *indicatorView;
// 布局方式
@property (nonatomic ,assign) DNTitleComponentViewIndictorType indicatorType;
// 索引文案数组
@property (nonatomic ,strong) NSArray *titlesArray;

@end

@implementation DNTitleComponentView

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray *)titlesArr delegate:(id<DNTitleComponentViewDelegate>)delegate indicatorType:(DNTitleComponentViewIndictorType)indicatorType
{
    if (self = [super initWithFrame:frame]) {
        [self initWithProperty];
        self.titlesArray = titlesArr;
        self.delegate = delegate;
        self.indicatorType = indicatorType;
        [self setNeedsLayout];
    }
    return self;
}

- (void)initWithProperty
{
    self.itemMargin = 20;
    self.selectIndex = 0;
    self.titleNormalColor = DNRGBA(0x33, 0x33, 0x33, 1.0);
    self.titleSelectColor = DNRGBA(0x2F, 0x88, 0xFF, 1.0);
    self.titleFont = [UIFont systemFontOfSize:15.0];
    self.indicatorColor = self.titleSelectColor;
    self.indicatorExtension = 5.0f;
    self.titleSelectFont = self.titleFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    if (self.itemBtnArray.count == 0) {
        return;
    }
    CGFloat totalBtnWidth = 0.0;
    UIFont *titleFont = _titleFont;
    
    if (_titleFont != _titleSelectFont) {
        for (int idx = 0; idx < self.titlesArray.count; idx++) {
            UIButton *btn = [self.itemBtnArray objectAtIndex:idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [DNTitleComponentView getWidthWithString:[self.titlesArray objectAtIndex:idx] font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }else{
        for (NSString *title in self.titlesArray) {
            CGFloat itemBtnWidth = [DNTitleComponentView getWidthWithString:title font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    
    if (totalBtnWidth <= CGRectGetWidth(self.bounds)) {
        // 不能滑动
        CGFloat itemBtnWidth = CGRectGetWidth(self.bounds)/self.itemBtnArray.count;
        CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
        [self.itemBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * itemBtnWidth, 0, itemBtnWidth, itemBtnHeight);
        }];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
    }else{
        // 超出屏幕，可以滑动
        CGFloat currentX = 0;
        for (int idx = 0; idx < self.titlesArray.count; idx++) {
            UIButton *btn = [self.itemBtnArray objectAtIndex:idx];
            titleFont = btn.isSelected?_titleSelectFont:titleFont;
            CGFloat itemBtnWidth = [DNTitleComponentView getWidthWithString:[self.titlesArray objectAtIndex:idx] font:titleFont] + self.itemMargin;
            CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
            btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
            currentX += itemBtnWidth;
        }
        self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
    }
    [self moveIndicatorView:YES];
}


- (void)moveIndicatorView:(BOOL)animated
{
    UIFont *titleFont = _titleFont;
    UIButton *selectBtn = [self.itemBtnArray objectAtIndex:self.selectIndex];
    titleFont = selectBtn.isSelected ? _titleSelectFont : _titleFont;
    CGFloat indicatorWidth = [DNTitleComponentView getWidthWithString:[self.titlesArray objectAtIndex:self.selectIndex]  font:titleFont];
    [UIView animateWithDuration:animated?0.05:0 animations:^{
        switch (self.indicatorType) {
            case DNTitleComponentViewDefault:
                self.indicatorView.frame = CGRectMake(selectBtn.frame.origin.x , CGRectGetHeight(self.scrollView.bounds) - 2, CGRectGetWidth(selectBtn.bounds), 2);
                break;
            case DNTitleComponentViewEqualTitle:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, 2);
                break;
            case DNTitleComponentViewCustom:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth + _indicatorExtension*2, 2);
                break;
            case DNTitleComponentViewNone:
                self.indicatorView.frame = CGRectZero;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self scrollSelectBtnCenter:animated];
    }];
}

- (void)scrollSelectBtnCenter:(BOOL)animated
{
    UIButton *selectBtn = [self.itemBtnArray objectAtIndex:self.selectIndex];
    CGRect centerRect = CGRectMake(selectBtn.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}


#pragma mark lazy load
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray<UIButton *> *)itemBtnArray
{
    if (!_itemBtnArray) {
        _itemBtnArray = [[NSMutableArray alloc] init];
    }
    return _itemBtnArray;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        [self.scrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --setter
- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    [self.itemBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtnArray = nil;
    for (NSString *title in titlesArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtnArray.count + kBtnTagConfigValue;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = _titleFont;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.itemBtnArray.count == self.selectIndex) {
            btn.selected = YES;
        }
        [self.itemBtnArray addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex || _selectIndex < 0 || _selectIndex > self.itemBtnArray.count - 1) {
        return;
    }
    
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + kBtnTagConfigValue];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = _titleFont;
    _selectIndex = selectIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + kBtnTagConfigValue];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = _titleSelectFont;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArray) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont
{
    if (_titleFont == titleSelectFont) {
        _titleSelectFont = _titleFont;
        return;
    }
    
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArray) {
        btn.titleLabel.font = btn.isSelected?titleSelectFont:_titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorExtension:(CGFloat)indicatorExtension
{
    _indicatorExtension = indicatorExtension;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)btnClick:(UIButton*)btn
{
    NSInteger index = btn.tag - kBtnTagConfigValue;
    if (index == self.selectIndex) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentTitleView:startIndex:endIndex:)]) {
        [self.delegate pageContentTitleView:self startIndex:self.selectIndex endIndex:index];
    }
    self.selectIndex = index;
}

#pragma mark Private
+ (CGFloat)getWidthWithString:(NSString*)string font:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}



@end
