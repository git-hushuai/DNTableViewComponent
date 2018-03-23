//
//  DNBottomTableViewCell.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "DNBottomTableViewCell.h"
#import "DNSubItemContentVC.h"

@implementation DNBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
}

/**
 是否可以滑动

 @param cellCanScroll <#cellCanScroll description#>
 */
- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    for (DNSubItemContentVC *vc in _viewControllers) {
        vc.vcCanScroll = cellCanScroll;
        if (!cellCanScroll) {
            [vc resetTableViewOffSet];
        }
    }
}

/**
 是否需要刷新

 @param isRefresh <#isRefresh description#>
 */
- (void)setIsRefresh:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
    for (DNSubItemContentVC *vc in self.viewControllers) {
        if ([vc.title isEqualToString:self.currentTagStr]) {
            vc.isRefresh = isRefresh;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
