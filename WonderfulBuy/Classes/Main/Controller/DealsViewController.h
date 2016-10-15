//
//  DealsViewController.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/26.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//  团购列表控制器(父类)

#import <UIKit/UIKit.h>

@interface DealsViewController : UICollectionViewController
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
@end
