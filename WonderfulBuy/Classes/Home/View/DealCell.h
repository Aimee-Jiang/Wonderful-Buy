//
//  DealCell.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/10.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Deal, DealCell;

@protocol DealCellDelegate <NSObject>

@optional
- (void)dealCellCheckingStateDidChange:(DealCell *)cell;

@end

@interface DealCell : UICollectionViewCell
@property (nonatomic, strong) Deal *deal;
@property (nonatomic, weak) id<DealCellDelegate> delegate;
@end
