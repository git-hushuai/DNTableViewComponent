//
//  DNSubItemContentVC.h
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNSubItemContentVC : UIViewController
@property (nonatomic, assign) BOOL vcCanScroll;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;
- (void)resetTableViewOffSet;
@end
