//
//  MetaTool.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/15.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductCategory, Deal;

@interface MetaTool : NSObject

/**
 *  return 344 cities
 */
+ (NSArray *)cities;

/**
 *  return all the categories
 */
+ (NSArray *)categories;
+ (ProductCategory *)categoryWithDeal:(Deal *)deal;

/**
 *  return all the sorts
 */
+ (NSArray *)sorts;

@end
