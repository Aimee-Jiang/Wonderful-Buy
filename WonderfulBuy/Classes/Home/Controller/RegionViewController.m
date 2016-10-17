//
//  RegionViewController.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/17.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "RegionViewController.h"
#import "HomeDropdown.h"
#import "UIView+Extension.h"
#import "CityViewController.h"
#import "NavigationController.h"
#import "Region.h"
#import "MTConst.h"

@interface RegionViewController () <HomeDropdownDataSource, HomeDropdownDelegate>
- (IBAction)changeCity;
@end

@implementation RegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    HomeDropdown *dropdown = [HomeDropdown dropdown];
    dropdown.y = title.height;
    dropdown.dataSource = self;
    dropdown.delegate = self;
    [self.view addSubview:dropdown];
    
    // 设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}

- (IBAction)changeCity {
    [self.popover dismissPopoverAnimated:YES];
    
    CityViewController *city = [[CityViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - HomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(HomeDropdown *)homeDropdown
{
    return self.regions.count;
}

- (NSString *)homeDropdown:(HomeDropdown *)homeDropdown titleForRowInMainTable:(int)row
{
    Region *region = self.regions[row];
    return region.name;
}

- (NSArray *)homeDropdown:(HomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row
{
    Region *region = self.regions[row];
    return region.subregions;
}

#pragma mark - HomeDropdownDelegate
- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row
{
    Region *region = self.regions[row];
    if (region.subregions.count == 0) {
      
        [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{MTSelectRegion : region}];
    }
}

- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow
{
    Region *region = self.regions[mainRow];

    [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{MTSelectRegion : region, MTSelectSubregionName : region.subregions[subrow]}];
}
@end
