//
//  CustomTabBarViewController.m
//  TeamHouseApp
//
//  Created by 李仁兵 on 14-1-7.
//  Copyright (c) 2014年 liu faliang. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()
{
    CGRect oldRect;
    CGRect hidenRect;
    CustomTabBarView * tabBarView;
}

@end

@implementation CustomTabBarViewController
@synthesize controllers = _controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBar.hidden = YES;
        oldRect = CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH, TABBAR_OFFSET);
        hidenRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TABBAR_OFFSET);
        tabBarView = [[CustomTabBarView alloc] initWithFrame:oldRect];
        tabBarView.delegate = self;
        [self.view addSubview:tabBarView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)setControllers:(NSArray *)controllers
{
    self.viewControllers = controllers;
    _controllers = controllers;
    tabBarView.numberOfController = [controllers count];
}

- (void)hidenTabBarAndCustomBar:(BOOL)isHiden
{
    if (isHiden) {
        [UIView animateWithDuration:0.5f animations:^{
            tabBarView.frame = hidenRect;
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            tabBarView.frame = oldRect;
        }];
    }
}


#pragma mark - CustomTabBarViewDelegate

- (void)touchBtn:(NSInteger)btnTag
{
    self.selectedIndex = btnTag;
}

@end
