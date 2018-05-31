//
//  ViewController.m
//  Demo
//
//  Created by xianghui on 2018/5/31.
//  Copyright © 2018年 xianghui. All rights reserved.
//

#import "ViewController.h"
#import "XHSegmentedView.h"

@interface ViewController ()<XHSegmentedViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) XHSegmentedView *segmentedView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.segmentedView = [[XHSegmentedView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 46)];
    self.segmentedView.backgroundColor = [UIColor redColor];
    self.segmentedView.delegate = self;
    [self.view addSubview:self.segmentedView];
    
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46+50, self.view.frame.size.width, self.view.frame.size.height-46-50)];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    [self.view addSubview:self.contentScrollView];
    
    NSArray *titles = @[@"test1" ,@"test123123123123"];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(idx*self.contentScrollView.frame.size.width, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
        view.backgroundColor = idx?[UIColor blueColor]:[UIColor orangeColor];
        [self.contentScrollView addSubview:view];
    }];
    
    self.segmentedView.titles = titles;
    [self.segmentedView updateSubViews];
    
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width*titles.count, self.contentScrollView.frame.size.height)];
}


#pragma mark WWSegmentedViewDelegate
- (void)segmentedView:(XHSegmentedView *)segmentedView didSelectedIndex:(NSInteger)index{
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width*index, 0) animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.segmentedView configAnimationOffsetX:self.contentScrollView.contentOffset.x contentWidth:self.contentScrollView.frame.size.width];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
