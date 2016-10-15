//
//  MTRegionViewController.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
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

/**
 *  切换城市
 */
- (IBAction)changeCity {
    [self.popover dismissPopoverAnimated:YES];
    
    CityViewController *city = [[CityViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
    // self.presentedViewController会引用着被modal出来的控制器
    // modal出来的是MTNavigationController
    // dismiss掉的应该也是MTNavigationController
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

#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row
{
    Region *region = self.regions[row];
    if (region.subregions.count == 0) {
        // 发出通知
        [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{MTSelectRegion : region}];
    }
}

- (void)homeDropdown:(HomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow
{
    Region *region = self.regions[mainRow];
    // 发出通知
    [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{MTSelectRegion : region, MTSelectSubregionName : region.subregions[subrow]}];
}
@end
