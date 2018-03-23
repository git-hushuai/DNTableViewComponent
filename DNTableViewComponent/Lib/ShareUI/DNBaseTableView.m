//
//  DNBaseTableView.m
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import "DNBaseTableView.h"

@interface DNBaseTableView()<UIGestureRecognizerDelegate>
@end

@implementation DNBaseTableView


/**
同时识别多个手势

@param gestureRecognizer <#gestureRecognizer description#>
@param otherGestureRecognizer <#otherGestureRecognizer description#>
@return <#return value description#>
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
