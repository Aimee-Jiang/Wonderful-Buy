//
//  HomeTopItem.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/13.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopItem : UIView
+ (instancetype)item;

/**
 *  设置点击的监听器
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
@end
