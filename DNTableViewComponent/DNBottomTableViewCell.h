//
//  DNBottomTableViewCell.h
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNSubVCContainerView.h"
@interface DNBottomTableViewCell : UITableViewCell

@property (nonatomic, strong) DNSubVCContainerView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) NSString *currentTagStr;
@end
