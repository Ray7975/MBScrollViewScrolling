//
//  UIImage+Expand.h
//  MBScrollViewScrolling
//  功能描述 - 图片扩展
//  Created by yulei on 15/5/17.
//  Copyright (c) 2015年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Expand)

//从文件内容读取图片
+ (UIImage *)imageWithContentOfFile:(NSString *)path;

//创建图片指定颜色和大小
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size;

- (UIImage *)fixOrientation;

@end
