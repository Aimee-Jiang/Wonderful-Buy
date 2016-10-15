//
//  Deal.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/21.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "Deal.h"
#import "MJExtension.h"
#import "Business.h"

@implementation Deal
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [Business class]};
}

- (BOOL)isEqual:(Deal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

MJCodingImplementation
@end
