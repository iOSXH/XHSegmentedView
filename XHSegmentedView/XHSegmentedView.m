//
//  XHSegmentedView.m
//  Wawaji
//
//  Created by xianghui on 2018/5/30.
//  Copyright © 2018年 same. All rights reserved.
//

#import "XHSegmentedView.h"

@interface XHSegmentedView()

@property (nonatomic, strong) NSMutableArray *titleBtns;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation XHSegmentedView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)initDatas{
    self.titleBtns = [[NSMutableArray alloc] init];
    
    self.titleWidthAdjust = YES;
    self.titleInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.titleSpace = 42;
    self.indicatorHeight = 2;
    self.indicatorBottomSpace = 8;
    self.indicatorWidthScale = 0.5;
    self.indicatorColor = [UIColor blackColor];
    self.titleSelColor = [UIColor blackColor];
    self.titleNorColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.titleSelFont = [UIFont systemFontOfSize:14];
    self.titleNorFont = [UIFont systemFontOfSize:14];
    self.animatedDuration = 0.25;
}

- (void)updateSubViews{
    if (self.titles.count <= 0) {
        return;
    }
    
    if (!self.contentScrollView) {
        self.contentScrollView = [[UIScrollView alloc] init];
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentScrollView];
    }
    
    if (!self.indicatorView) {
        self.indicatorView = [[UIView alloc] init];
        self.indicatorView.layer.masksToBounds = YES;
        [self.contentScrollView addSubview:self.indicatorView];
    }
    self.indicatorView.layer.cornerRadius = self.indicatorHeight/2;
    self.indicatorView.frame = CGRectMake(0, self.frame.size.height-self.indicatorHeight-self.indicatorBottomSpace, 0, self.indicatorHeight);
    self.indicatorView.backgroundColor = self.indicatorColor;
    
    [self.titleBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn removeFromSuperview];
    }];
    [self.titleBtns removeAllObjects];
    
    __block CGFloat contentWidth = 0;
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        CGFloat titleWidth = self.titleWidth;
        if (self.titleWidthAdjust) {
            titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:self.titleSelFont}].width;
            titleWidth += (self.titleInsets.left + self.titleInsets.right);
            titleWidth = MAX(MAX(titleWidth, self.titleMinWidth), self.titleMaxWidth);
        }
        
        CGFloat indicatorWith = titleWidth * self.indicatorWidthScale;
        
        NSAttributedString *norTitleAtt = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:self.titleNorFont, NSForegroundColorAttributeName:self.titleNorColor}];
        NSAttributedString *selTitleAtt = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:self.titleSelFont, NSForegroundColorAttributeName:self.titleSelColor}];
        
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(contentWidth + self.titleSpace*idx, 0, titleWidth, self.frame.size.height);
        titleBtn.tag = 10 + idx;
        [titleBtn addTarget:self action:@selector(titleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:titleBtn];
        [self.titleBtns addObject:titleBtn];
        
        if (self.currentIndex == idx) {
            [titleBtn setSelected:YES];
            self.indicatorView.frame = CGRectMake(titleBtn.frame.origin.x - (indicatorWith/2 - titleWidth/2), self.frame.size.height-self.indicatorHeight-self.indicatorBottomSpace, indicatorWith, self.indicatorHeight);
            
            [titleBtn setAttributedTitle:selTitleAtt forState:UIControlStateNormal];
            [titleBtn setAttributedTitle:selTitleAtt forState:UIControlStateSelected];
        }else{
            
            [titleBtn setAttributedTitle:norTitleAtt forState:UIControlStateNormal];
            [titleBtn setAttributedTitle:norTitleAtt forState:UIControlStateSelected];
        }
        
        contentWidth = titleBtn.frame.origin.x + titleBtn.frame.size.width;
        
    }];
    
    [self.contentScrollView setContentSize:CGSizeMake(contentWidth, 0)];
    
    if (contentWidth > self.frame.size.width) {
        self.contentScrollView.scrollEnabled = YES;
        self.contentScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }else{
        self.contentScrollView.scrollEnabled = NO;
        self.contentScrollView.frame = CGRectMake(self.frame.size.width/2 - contentWidth/2, 0, contentWidth, self.frame.size.height);
    }
}

- (void)titleBtnDidClicked:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    NSInteger index = sender.tag - 10;
    
    if ([self.delegate respondsToSelector:@selector(segmentedView:didSelectedIndex:)]) {
        [self.delegate segmentedView:self didSelectedIndex:index];
    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex{

    NSInteger lastIndex = _currentIndex;

    _currentIndex = currentIndex;

    if (self.contentScrollView && self.titleBtns.count > currentIndex) {
        UIButton *lastSelBtn = [self.titleBtns objectAtIndex:lastIndex];
        [lastSelBtn setSelected:NO];

        UIButton *currentSelBtn = [self.titleBtns objectAtIndex:currentIndex];
        [currentSelBtn setSelected:YES];
    }
}


- (void)configAnimationOffsetX:(CGFloat)offsetX contentWidth:(CGFloat)contentWidth{
    
    NSInteger index = 0;
    if (offsetX >= 0) {
        index = offsetX/contentWidth;
    }
    CGFloat dif = offsetX - index*contentWidth;
    
    if (index >= self.titleBtns.count) {
        return;
    }
    
    UIButton *indexBtn = [self.titleBtns objectAtIndex:index];
    CGFloat indicatorWith = indexBtn.frame.size.width * self.indicatorWidthScale;
    
    CGFloat indicatorX = indexBtn.frame.origin.x - (indicatorWith/2 - indexBtn.frame.size.width/2);
    
    CGFloat nextIndex = index + 1;
    
    
    CGFloat nextIndicatorWith = 0;
    CGFloat nextIndicatorX = 0;
    UIButton *nextIndexBtn = nil;
    
    if (nextIndex < self.titles.count) {
        nextIndexBtn = [self.titleBtns objectAtIndex:nextIndex];
        nextIndicatorWith = nextIndexBtn.frame.size.width * self.indicatorWidthScale;
        nextIndicatorX = nextIndexBtn.frame.origin.x - (nextIndicatorWith/2 - nextIndexBtn.frame.size.width/2);
    }else{
        nextIndicatorWith = indicatorWith;
        nextIndicatorX = indexBtn.frame.origin.x + indexBtn.frame.size.width;
    }
    
    CGFloat indicatorSpace = nextIndicatorX - indicatorX;
    CGFloat scale = dif/contentWidth;
    self.indicatorView.frame = CGRectMake(indicatorX + indicatorSpace*scale , self.frame.size.height-self.indicatorHeight-self.indicatorBottomSpace, indicatorWith + (nextIndicatorWith - indicatorWith)*scale, self.indicatorHeight);
    
    CGFloat startR = 0.0;
    CGFloat startG = 0.0;
    CGFloat startB = 0.0;
    CGFloat startA = 0.0;
    [self.titleSelColor getRed:&startR green:&startG blue:&startB alpha:&startA];
    
    CGFloat endR = 0.0;
    CGFloat endG = 0.0;
    CGFloat endB = 0.0;
    CGFloat endA = 0.0;
    [self.titleNorColor getRed:&endR green:&endG blue:&endB alpha:&endA];
    
    CGFloat colorScale = scale>1?1:(scale<0?0:scale);
    
    UIColor *startColor = [UIColor colorWithRed:startR + (endR-startR)*colorScale green:startG + (endG-startG)*colorScale blue:startB + (endB-startB)*colorScale alpha:startA + (endA-startA)*colorScale];
    
    NSAttributedString *titleAtt = [[NSAttributedString alloc] initWithString:indexBtn.currentAttributedTitle.string attributes:@{NSFontAttributeName:self.titleSelFont, NSForegroundColorAttributeName:startColor}];
    [indexBtn setAttributedTitle:titleAtt forState:UIControlStateNormal];
    [indexBtn setAttributedTitle:titleAtt forState:UIControlStateSelected];

    if (nextIndexBtn) {
        
        UIColor *endColor = [UIColor colorWithRed:endR + (startR-endR)*colorScale green:endG + (startG-endG)*colorScale blue:endB + (startB-endB)*colorScale alpha:endA + (startA-endA)*colorScale];

        NSAttributedString *nextTitleAtt = [[NSAttributedString alloc] initWithString:nextIndexBtn.currentAttributedTitle.string attributes:@{NSFontAttributeName:self.titleSelFont, NSForegroundColorAttributeName:endColor}];
        [nextIndexBtn setAttributedTitle:nextTitleAtt forState:UIControlStateNormal];
        [nextIndexBtn setAttributedTitle:nextTitleAtt forState:UIControlStateSelected];
    }
    
    
    
    
    if (index != self.currentIndex) {
        self.currentIndex = index;
    }
}


@end
