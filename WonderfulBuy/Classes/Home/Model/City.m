//
//  City.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/16.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "City.h"
#import "MJExtension.h"
#import "Region.h"

@implementation City
- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [Region class]};
}
@end
