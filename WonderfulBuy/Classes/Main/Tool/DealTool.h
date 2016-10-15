//
//  DealTool.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/16.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deal;

@interface DealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;
/**
 *  collect a product
 */
+ (void)addCollectDeal:(Deal *)deal;
/**
 *  cancel collecting a product
 */
+ (void)removeCollectDeal:(Deal *)deal;

+ (BOOL)isCollected:(Deal *)deal;
@end
