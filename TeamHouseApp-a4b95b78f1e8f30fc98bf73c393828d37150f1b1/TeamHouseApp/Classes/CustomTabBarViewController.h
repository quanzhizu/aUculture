//
//  CustomTabBarViewController.h
//  TeamHouseApp
//
//  Created by 李仁兵 on 14-1-7.
//  Copyright (c) 2014年 liu faliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"

@interface CustomTabBarViewController : UITabBarController<CustomTabBarViewDelegate>
{
    __weak NSArray * _controllers;
}
@property (nonatomic,weak) NSArray * controllers;

- (void)hidenTabBarAndCustomBar:(BOOL)isHiden;

@end
