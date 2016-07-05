//
//  CJCarouselView.m
//  图片轮播
//
//  Created by chenjun on 16/7/5.
//  Copyright © 2016年 cloudssky. All rights reserved.
//

#import "CJCarouselView.h"

@interface CJCarouselView () <UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scroller;//scrollerView
@property (nonatomic ,strong) UIImageView *leftImageView;//左边的imageview
@property (nonatomic ,strong) UIImageView *showImageView;//展示的内容
@property (nonatomic ,strong) UIImageView *rightImageView;//右边的imageview

@property (nonatomic ,assign) int index;//当前展示的第几页
@property (nonatomic ,assign) CGFloat height;//高度
@property (nonatomic ,assign) CGFloat width;//宽度

@property (nonatomic ,strong) NSTimer *timer;//定时器、自动滚动

@property (nonatomic ,strong) UIPageControl *pageControl;//分页控件

@end

@implementation CJCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.index = 0;
    [self addSubview:self.scroller];
    [self addSubview:self.pageControl];
    [self startTimer];
}

#pragma mark - private method
- (void)setIsHidePage:(BOOL)isHidePage {
    _isHidePage = isHidePage;
    if (isHidePage == YES) {
        self.pageControl.hidden = YES;
    }
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

- (void)setOtherPageColor:(UIColor *)otherPageColor {
    _otherPageColor = otherPageColor;
    self.pageControl.pageIndicatorTintColor = otherPageColor;
}

- (void)nextPic {
    if (self.direction == DirecLeft) {
        [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.scroller setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    }
    [self scrollViewDidEndDecelerating:self.scroller];
}

- (void)startTimer {
    if (self.timer) {
        [self stopTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPic) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)myClick {
    if ([self.delegate respondsToSelector:@selector(clickImage:)]) {
        [self.delegate clickImage:self.index];
    }
}

#pragma mark - setValue
- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    [self setViewFrame];
    _dataSourceArray = dataSourceArray;
    self.leftImageView.image = [dataSourceArray lastObject];
    self.showImageView.image = dataSourceArray[0];
    if (dataSourceArray.count == 1) {
        self.rightImageView.image = dataSourceArray[0];
    } else {
        self.rightImageView.image = dataSourceArray[1];
    }
    
    self.pageControl.frame = CGRectMake(0, self.height - 30, self.width, 30);
    self.pageControl.numberOfPages = dataSourceArray.count;
    self.pageControl.currentPage = self.index;
}

- (void)setViewFrame {
    self.height = self.frame.size.height;
    self.width = self.frame.size.width;

    _scroller.frame = CGRectMake(0, 0, self.width, self.height);
    _scroller.contentSize = CGSizeMake(self.width * 3, self.height);
    _scroller.contentOffset = CGPointMake(self.width, 0);
    
    self.leftImageView.frame = CGRectMake(0, 0, self.width, self.height);
    self.showImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.rightImageView.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x / self.width == 1) {
        return;
    } else if (scrollView.contentOffset.x / self.width < 1) {
        self.index--;
    } else {
        self.index++;
    }
    
    if (self.index < 0) {
        self.index = self.dataSourceArray.count - 1;
    } else if (self.index >= self.dataSourceArray.count) {
        self.index = 0;
    }
    
    if (self.index - 1 < 0) {
        self.leftImageView.image = [self.dataSourceArray lastObject];
    } else {
        self.leftImageView.image = self.dataSourceArray[self.index -1];
    }
    self.showImageView.image = self.dataSourceArray[self.index];
    if (self.index + 1 >= self.dataSourceArray.count) {
        self.rightImageView.image = self.dataSourceArray[0];
    } else {
        self.rightImageView.image = self.dataSourceArray[self.index + 1];
    }
    
    scrollView.contentOffset = CGPointMake(self.width, 0);
    self.pageControl.currentPage = self.index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < self.width * 0.5) {
        int currentIndex = self.index - 1;
        if (currentIndex < 0) {
            currentIndex = self.dataSourceArray.count - 1;
        }
        self.pageControl.currentPage = currentIndex;
    } else if (scrollView.contentOffset.x > self.width * 1.5) {
        int currentIndex = self.index + 1;
        if (currentIndex >= self.dataSourceArray.count) {
            currentIndex = 0;
        }
        self.pageControl.currentPage = currentIndex;
    }
}

#pragma mark - getter and setter
- (UIScrollView *)scroller {
    if (_scroller == nil) {
        _scroller = [[UIScrollView alloc] init];
        [self addSubview:_scroller];
        _scroller.delegate = self;
        _scroller.pagingEnabled = YES;
        _scroller.showsVerticalScrollIndicator = NO;
        _scroller.showsHorizontalScrollIndicator = NO;
        _scroller.bounces = NO;
        
        [_scroller addSubview:self.leftImageView];
        [_scroller addSubview:self.showImageView];
        [_scroller addSubview:self.rightImageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myClick)];
        [_scroller addGestureRecognizer:gesture];
    }
    return _scroller;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIImageView *)showImageView {
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

@end
