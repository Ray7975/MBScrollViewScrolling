//
//  UIView+frameAdjust.h
//  MBScrollViewScrolling
//  功能描述 - UIView坐标调整
//  Created by yulei on 15/10/13.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameAdjust)

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

@end
