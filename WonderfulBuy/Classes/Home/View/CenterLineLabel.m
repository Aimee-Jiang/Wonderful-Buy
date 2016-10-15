//
//  CenterLineLabel.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/13.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "CenterLineLabel.h"

@implementation CenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();

//    CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5);
//    // 连线到另一个点
//    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5);
//    // 渲染
//    CGContextStrokePath(ctx);
}

@end
