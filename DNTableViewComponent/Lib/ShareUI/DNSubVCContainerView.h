//
//  DNSubVCContainerView.h
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DNSubVCContainerView;

@protocol DNSubVCContainerViewDelegate <NSObject>

@optional

/**
 DNSubVCContainerView 开始滑动
 
 @param contentView DNSubVCContainerView
 */
- (void)DNSubVCContainerViewWillBeginDraggng:(DNSubVCContainerView*)contentView;

/**
 DNSubVCContainerView 滑动调用
 
 @param contentView DNSubVCContainerView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)DNSubVCContainerViewDidScroll:(DNSubVCContainerView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 DNSubVCContainerView 结束滑动
 
 @param contentView DNSubVCContainerView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)DNSubVCContainerViewDidEndDecelerating:(DNSubVCContainerView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
/**
 DNSubVCContainerView 滑动结束调用
 
 @param contentView DNSubVCContainerView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)DNSubVCContainerViewDidEndScroll:(DNSubVCContainerView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

@end


@interface DNSubVCContainerView : UIView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<DNSubVCContainerViewDelegate>)delegate;

@property (nonatomic ,weak) id<DNSubVCContainerViewDelegate> delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
