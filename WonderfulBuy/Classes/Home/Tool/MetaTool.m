//
//  MetaTool.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/15.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "MetaTool.h"
#import "City.h"
#import "ProductCategory.h"
#import "Sort.h"
#import "MJExtension.h"
#import "Deal.h"

@implementation MetaTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [City objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [ProductCategory objectArrayWithFilename:@"categories.plist"];;
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [Sort objectArrayWithFilename:@"sorts.plist"];;
    }
    return _sorts;
}


+ (ProductCategory *)categoryWithDeal:(Deal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (ProductCategory *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
    }
    return nil;
}
@end
