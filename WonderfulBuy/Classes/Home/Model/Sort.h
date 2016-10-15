//
//  Sort.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/18.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sort : NSObject
/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic, assign) int value;
@end
