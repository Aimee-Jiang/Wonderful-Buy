//
//  CityGroup.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/16.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityGroup : NSObject
/** group title */
@property (nonatomic, copy) NSString *title;
/** all the cities in group */
@property (nonatomic, strong) NSArray *cities;
@end
