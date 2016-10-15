//
//  Region.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/16.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *subregions;
@end
