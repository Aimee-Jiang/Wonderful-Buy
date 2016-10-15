//
//  HomeDropdown.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/12.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "HomeDropdown.h"
#import "HomeDropdownMainCell.h"
#import "HomeDropdownSubCell.h"

@interface HomeDropdown() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
/** 左边主表选中的行号 */
@property (nonatomic, assign) NSInteger selectedMainRow;
@end

@implementation HomeDropdown

+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeDropdown" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowsInMainTable:self];
    } else {
        return [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView) {
        cell = [HomeDropdownMainCell cellWithTableView:tableView];
        
        // 取出模型数据
        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropdown:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 从表
        cell = [HomeDropdownSubCell cellWithTableView:tableView];
        
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow];
        cell.textLabel.text = subdata[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 被点击的数据
        self.selectedMainRow = indexPath.row;
        // 刷新右边的数据
        [self.subTableView reloadData];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInMainTable:indexPath.row];
        }
    } else {
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInSubTable:inMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInSubTable:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
}
@end
