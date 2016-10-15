//
//  CollectViewController.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/24.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "CollectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTConst.h"
#import "DealTool.h"
#import "DealCell.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
#import "Deal.h"

NSString *const MTDone = @"完成";
NSString *const MTEdit = @"编辑";
#define MTString(str) [NSString stringWithFormat:@"  %@  ", str]

@interface CollectViewController () <DealCellDelegate>
@property (nonatomic, weak) UIImageView *noDataView;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;
@end

@implementation CollectViewController
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
        self.removeItem.enabled = NO;
    }
    return _removeItem;
}

- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

static NSString * const reuseIdentifier = @"deal";
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的团购";
    self.collectionView.backgroundColor = MTGlobalBg;
    
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    [self loadMoreDeals];
    
    [MTNotificationCenter addObserver:self selector:@selector(collectStateChange:) name:MTCollectStateDidChangeNotification object:nil];
    
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
}

- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:MTEdit]) {
        item.title = MTDone;
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.removeItem];
        
        for (Deal *deal in self.deals) {
            deal.editing = YES;
        }
    } else {
        item.title = MTEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        for (Deal *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)selectAll
{
    for (Deal *deal in self.deals) {
        deal.checking = YES;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = YES;
}

- (void)unselectAll
{
    for (Deal *deal in self.deals) {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

- (void)remove
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (Deal *deal in self.deals) {
        if (deal.isChecking) {
            [DealTool removeCollectDeal:deal];
            
            [tempArray addObject:deal];
        }
    }
    
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

- (void)loadMoreDeals
{
    // add page
    self.currentPage++;
    
    // add new data
    [self.deals addObjectsFromArray:[DealTool collectDeals:self.currentPage]];
    
    // refresh view
    [self.collectionView reloadData];
    
    [self.collectionView footerEndRefreshing];
}

- (void)collectStateChange:(NSNotification *)notification
{
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    [self loadMoreDeals];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - cell的代理
- (void)dealCellCheckingStateDidChange:(DealCell *)cell
{
    BOOL hasChecking = NO;
    for (Deal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
    
    self.removeItem.enabled = hasChecking;
}

/**
 when screen change
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // calculate column
    int cols = (size.width == 1024) ? 3 : 2;
    
    // calculate inset
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // set distance between
    layout.minimumLineSpacing = 50;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // calculate distance
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // control footer hidden view
    self.collectionView.footerHidden = (self.deals.count == [DealTool collectDealsCount]);
    
    // control no data view
    self.noDataView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
