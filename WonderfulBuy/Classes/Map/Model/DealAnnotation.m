//
//  DealAnnotation.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/29.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "DealAnnotation.h"

@implementation DealAnnotation
- (BOOL)isEqual:(DealAnnotation *)other
{
    return [self.title isEqual:other.title];
}
@end
