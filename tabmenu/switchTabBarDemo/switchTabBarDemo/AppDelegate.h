//
//  AppDelegate.h
//  switchTabBarDemo
//
//  Created by 张培川 on 13-12-17.
//  Copyright (c) 2013年 张培川. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwitchTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow                    *_window;
    SwitchTabBarController      *_switchTabBarController;
}

@property (strong, nonatomic)IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet SwitchTabBarController *switchTabBarController;
@end
