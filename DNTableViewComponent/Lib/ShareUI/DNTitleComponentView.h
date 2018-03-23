//
//  DNTitleComponentView.h
//  DNTableViewComponent
//
//  Created by 露乐ios on 2018/3/23.
//  Copyright © 2018年 hushuaike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNTitleComponentView;

typedef enum : NSUInteger{
    DNTitleComponentViewDefault, // 默认与按钮长度相同
    DNTitleComponentViewEqualTitle, // 与文字长度相同
    DNTitleComponentViewCustom, // 自定义文字边缘延伸宽度
    DNTitleComponentViewNone,
}DNTitleComponentViewIndictorType; // 指示器类型枚举

@protocol DNTitleComponentViewDelegate <NSObject>

@optional
/**
 切换标题
 
 @param titleView DNPageContentView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)pageContentTitleView:(DNTitleComponentView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end



@interface DNTitleComponentView : UIView


@property (nonatomic , weak) id<DNTitleComponentViewDelegate> delegate;
// 标题文字间距
@property (nonatomic ,assign) CGFloat itemMargin;
// 当前选中标题索引
@property (nonatomic ,assign) NSInteger selectIndex;
// 标题字体大小，默认15
@property (nonatomic ,assign) UIFont *titleFont;
// 标题选中字体大小，默认15
@property (nonatomic ,strong) UIFont *titleSelectFont;
// 标题正常颜色，默认#333333
@property (nonatomic ,strong) UIColor *titleNormalColor;
// 标题选中颜色，默认#2F88FF
@property (nonatomic ,strong) UIColor *titleSelectColor;
// 指示器颜色，默认与titleSelector一样，在FSindicatorTypeNone下无效
@property (nonatomic ,strong) UIColor *indicatorColor;
// 在FSIndicatorTypeCustom时可自定义此属性，为指示器一端延伸长度，默认5
@property (nonatomic ,assign) CGFloat indicatorExtension;


/**
 对象方法创建DNPageContentView
 
 @param frame frame
 @param titlesArr 标题数组
 @param delegate delegate
 @param indicatorType 指示器类型
 @return DNPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSArray *)titlesArr delegate:(id<DNTitleComponentViewDelegate>)delegate indicatorType:(DNTitleComponentViewIndictorType)indicatorType;


@end
