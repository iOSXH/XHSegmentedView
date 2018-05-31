//
//  XHSegmentedView.h
//  Wawaji
//
//  Created by xianghui on 2018/5/30.
//  Copyright © 2018年 same. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSegmentedView;

@protocol XHSegmentedViewDelegate <NSObject>

- (void)segmentedView:(XHSegmentedView *)segmentedView didSelectedIndex:(NSInteger)index;

@end


@interface XHSegmentedView : UIView



/**
 代理
 */
@property (nonatomic, weak) id<XHSegmentedViewDelegate> delegate;


/**
 标题数组
 */
@property (nonatomic, strong) NSArray<NSString *> *titles;


/**
 是否适应标题长度 默认Yes
 */
@property (nonatomic, assign) BOOL titleWidthAdjust;

/**
 标题左右间距 默认 0
 */
@property (nonatomic, assign) UIEdgeInsets titleInsets;

/**
 标题长度 titleWidthAdjust为NO时生效
 */
@property (nonatomic, assign) CGFloat titleWidth;

/**
 标题最大长度 titleWidthAdjust为Yes时生效 默认0 自适应字体长度
 */
@property (nonatomic, assign) CGFloat titleMaxWidth;

/**
 标题最小长度 titleWidthAdjust为NO时生效 默认0 自适应字体长度
 */
@property (nonatomic, assign) CGFloat titleMinWidth;

/**
 标题间距 默认 42
 */
@property (nonatomic, assign) CGFloat titleSpace;

/**
 选中指示器高度 默认 1
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 选中指示器底部间距 默认 8
 */
@property (nonatomic, assign) CGFloat indicatorBottomSpace;

/**
 选中指示器宽度与标题宽度比例 默认 0.5
 */
@property (nonatomic, assign) CGFloat indicatorWidthScale;

/**
 选中指示器颜色 默认 #313234
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 标题选中颜色 默认 #313234
 */
@property (nonatomic, strong) UIColor *titleSelColor;

/**
 标题正常颜色 默认 #313234 60%
 */
@property (nonatomic, strong) UIColor *titleNorColor;

/**
 标题选中字体 默认 14
 */
@property (nonatomic, strong) UIFont *titleSelFont;

/**
 标题正常字体 默认 14
 */
@property (nonatomic, strong) UIFont *titleNorFont;


/**
 动画时间 0 无动画 默认 0.5
 */
@property (nonatomic, assign) CGFloat animatedDuration;


/**
 当前选中标题index 默认 0
 */
@property (nonatomic, assign) NSInteger currentIndex;

- (void)updateSubViews;


- (void)configAnimationOffsetX:(CGFloat)offsetX contentWidth:(CGFloat)contentWidth;

@end
