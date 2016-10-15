//
//  RegionViewController.h
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/17.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionViewController : UIViewController
@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, weak) UIPopoverController *popover;
@end
