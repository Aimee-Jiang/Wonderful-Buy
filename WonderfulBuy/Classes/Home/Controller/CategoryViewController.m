//
//  CategoryViewController.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/16.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

/* bug */
// iPad中控制器的view的尺寸默认都是1024x768, HomeDropdown的尺寸默认是300x340
// CategoryViewController显示在popover中,尺寸变为480x320, HomeDropdown的尺寸也跟着减小:0x0

#import "CategoryViewController.h"
#import "HomeDropdown.h"
#import "UIView+Extension.h"
#import "ProductCategory.h"
#import "MJExtension.h"
#import "MetaTool.h"
#import "MTConst.h"

@interface CategoryViewController () <HomeDropdownDataSource, HomeDropdownDelegate>
@end

@implementation CategoryViewController

- (void)loadView
{
    HomeDropdown *dropdown = [HomeDropdown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    self.view = dropdown;
    
    // 设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - HomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(HomeDropdown *)homeDropdown
{
    return [MetaTool categories].count;
}

- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown titleForRowInMainTable:(int)row
{
    ProductCategory *category = [MetaTool categories][row];
    return category.name;
}

- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown iconForRowInMainTable:(int)row
{
    ProductCategory *category = [MetaTool categories][row];
    return category.small_icon;
}

- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown selectedIconForRowInMainTable:(int)row
{
    ProductCategory *category = [MetaTool categories][row];
    return category.small_highlighted_icon;
}

- (NSArray *)homeDropdown:(HomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row
{
    ProductCategory *category = [MetaTool categories][row];
    return category.subcategories;
}

#pragma mark - HomeDropdownDelegate
- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row
{
    ProductCategory *category = [MetaTool categories][row];
    if (category.subcategories.count == 0) {
    
        [MTNotificationCenter postNotificationName:MTCategoryDidChangeNotification object:nil userInfo:@{MTSelectCategory : category}];
    }
}

- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow
{
    ProductCategory *category = [MetaTool categories][mainRow];

    [MTNotificationCenter postNotificationName:MTCategoryDidChangeNotification object:nil userInfo:@{MTSelectCategory : category, MTSelectSubcategoryName : category.subcategories[subrow]}];
}
@end
