//
//  ScrollingViewController.m
//  MBScrollViewScrolling
//
//  Created by Admin on 15/10/23.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import "ScrollingViewController.h"
#import "MBScrollView.h"

@interface ScrollingViewController ()

@property (strong, nonatomic) MBScrollView *scrollingView;

@end

@implementation ScrollingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.scrollingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyload

- (MBScrollView *)scrollingView {
    if (_scrollingView == nil) {
        _scrollingView = [[MBScrollView alloc] initWithFrame:self.view.bounds];
        _scrollingView.backgroundColor = [UIColor clearColor];
        [_scrollingView setScrollViewPageingEnable:NO];
    }
    return _scrollingView;
}

@end
