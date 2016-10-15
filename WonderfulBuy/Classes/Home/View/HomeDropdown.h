//
//  HomeDropdown.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/12.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDropdown;

@protocol HomeDropdownDataSource <NSObject>
/**
 *  左边表格一共有多少行
 */
- (NSInteger)numberOfRowsInMainTable:(HomeDropdown *)homeDropdown;
/**
 *  左边表格每一行的标题
 *  @param row          行号
 */
- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown titleForRowInMainTable:(int)row;
/**
 *  左边表格每一行的子数据
 *  @param row          行号
 */
- (NSArray *)homeDropdown:(HomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row;

@optional
/**
 *  左边表格每一行的图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown iconForRowInMainTable:(int)row;
/**
 *  左边表格每一行的选中图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown selectedIconForRowInMainTable:(int)row;
@end

@protocol HomeDropdownDelegate <NSObject>

@optional
- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row;
- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow;
@end

@interface HomeDropdown : UIView
+ (instancetype)dropdown;
@property (nonatomic, weak) id<HomeDropdownDataSource> dataSource;
@property (nonatomic, weak) id<HomeDropdownDelegate> delegate;
@end
