//
//  MBScrollView.m
//  MBScrollViewScrolling
//
//  Created by Admin on 15/10/23.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import "MBScrollView.h"
#import "UIImage+Expand.h"
#import "UIView+frameAdjust.h"

@interface MBScrollView () <UIScrollViewDelegate> {
    CGFloat scrollViewWidth;
}

//滑动列表
@property (strong, nonatomic) UIScrollView *scrollView;
//分页控制器
@property (strong, nonatomic) UIPageControl *pageControl;

//可见试图
@property (strong, nonatomic) NSMutableArray *visiableViews;
//复用视图
@property (strong, nonatomic) NSMutableArray *reusedViews;
//图片数据
@property (strong, nonatomic) NSMutableArray *imageData;

//当前图片索引
@property (assign) NSInteger currentImageIndex;

@end

@implementation MBScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateSubviews];
    }
    return self;
}

#pragma mark - Main

//加载子试图
- (void)loadSubviews {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

//更新子试图
- (void)updateSubviews {
    scrollViewWidth = CGRectGetWidth(self.bounds);
    //加载子试图
    [self loadSubviews];
    
    _visiableViews = [[NSMutableArray alloc] initWithCapacity:3];
    _reusedViews = [[NSMutableArray alloc] initWithCapacity:3];
    _imageData = [NSMutableArray arrayWithObjects:@"pic_1.jpg",@"pic_2.jpg",@"pic_3.jpg",@"pic_4.jpg",@"pic_5.jpg", nil];

    _currentImageIndex = 0;
    _pageControl.currentPage = _currentImageIndex;
    _pageControl.numberOfPages = _imageData.count;
    
    //设置分页控制器frame
    CGSize size = [_pageControl sizeForNumberOfPages:_imageData.count];
    [_pageControl setFrame:CGRectMake((CGRectGetWidth(self.bounds)-size.width)/2, CGRectGetHeight(_scrollView.bounds), size.width, size.height)];
    //设置滑动试图content size
    [_scrollView setContentSize:CGSizeMake(scrollViewWidth*3, 0)];
    
    //重载数据
    [self reloadData];
}

//获取重用试图
- (UIImageView *)reusedImageViewAtImageIndex:(NSInteger)_index {
    UIImageView *imageView = [self.reusedViews firstObject];
    if (imageView) {
        [self.reusedViews removeObject:imageView];
    } else {
        imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
    }
    
    NSString *imageName = [_imageData objectAtIndex:_index];
    imageView.image = [UIImage imageWithContentOfFile:imageName];
    [self.visiableViews addObject:imageView];
    return imageView;
}

//重载数据
- (void)reloadData {
    //设置当前页码
    _pageControl.currentPage = _currentImageIndex;
    
    for (UIView *view in _visiableViews) {
        [view removeFromSuperview];
        [_reusedViews addObject:view];
    }

    UIImageView *leftImageView = [self reusedImageViewAtImageIndex:(_currentImageIndex+_imageData.count-1)%_imageData.count];
    [leftImageView setX:0];
    [_scrollView addSubview:leftImageView];
    
    UIImageView *centerImageView = [self reusedImageViewAtImageIndex:_currentImageIndex];
    [centerImageView setX:scrollViewWidth];
    [_scrollView addSubview:centerImageView];
    
    UIImageView *rightImageView = [self reusedImageViewAtImageIndex:(_currentImageIndex+1)%_imageData.count];
    [rightImageView setX:scrollViewWidth*2];
    [_scrollView addSubview:rightImageView];

    [_scrollView setContentOffset:CGPointMake(scrollViewWidth, 0)];
}

//滑动
- (void)scrollViewDidScrolling {
    CGFloat currentOffsetX = _scrollView.contentOffset.x;
    if (currentOffsetX >= scrollViewWidth*2) {
        _currentImageIndex = (_currentImageIndex+1)%_imageData.count;
        //重载数据
        [self reloadData];
    } else if (currentOffsetX <= 0) {
        _currentImageIndex = (_currentImageIndex+_imageData.count-1)%_imageData.count;
        //重载数据
        [self reloadData];
    }
}

//滑动结束
- (void)scrollViewDidEndScrolling {
    CGFloat currentOffsetX = _scrollView.contentOffset.x;
    //修复滑动停止时整页翻动效果
    if (currentOffsetX < scrollViewWidth/2) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (currentOffsetX > scrollViewWidth*1.5) {
        [_scrollView setContentOffset:CGPointMake(scrollViewWidth*2, 0) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(scrollViewWidth, 0) animated:YES];
    }
}

#pragma mark - Open Method

//设置是否整页滑动
- (void)setScrollViewPageingEnable:(BOOL)status {
    if (_scrollView.pagingEnabled != status) {
        _scrollView.pagingEnabled = status;
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //滑动
    [self scrollViewDidScrolling];
}

//拖拽结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //解决拖拽不滑行问题
    if (!scrollView.pagingEnabled && !decelerate) {
        //滑动结束
        [self scrollViewDidEndScrolling];
    }
}

//拖拽滑行结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!scrollView.pagingEnabled) {
        //滑动结束
        [self scrollViewDidEndScrolling];
    }
}

#pragma mark - lazyload

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, ceilf(scrollViewWidth/320)*300)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = NO;
        _scrollView.contentMode = UIViewContentModeScaleAspectFill;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    return _pageControl;
}

@end
