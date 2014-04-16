//
//  AppDelegate.m
//  switchTabBarDemo
//
//  Created by 张培川 on 13-12-17.
//  Copyright (c) 2013年 张培川. All rights reserved.
//

#import "AppDelegate.h"
#import "SwitchTabBarController.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize switchTabBarController = _switchTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self initTabBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initTabBar
{
    UIViewController *Rim = [[UIViewController alloc] init];
    Rim.view.backgroundColor = [self randomColor];
    UINavigationController * RimNav = [[UINavigationController alloc] initWithRootViewController:Rim];
    
    UIViewController *Recommend = [[UIViewController alloc] init];
    UINavigationController * RecommendNav = [[UINavigationController alloc] initWithRootViewController:Recommend];
    Recommend.view.backgroundColor = [self randomColor];
    
    UIViewController *search = [[UIViewController alloc] init];
    UINavigationController * SearchNav = [[UINavigationController alloc] initWithRootViewController:search];
    search.view.backgroundColor = [self randomColor];
    
    UIViewController *More = [[UIViewController alloc]init];
    UINavigationController * MoreNav = [[UINavigationController alloc] initWithRootViewController:More];
    More.view.backgroundColor = [self randomColor];
    
    UIViewController *Shop = [[UIViewController alloc] init];
    UINavigationController * ShopNav = [[UINavigationController alloc] initWithRootViewController:Shop];
    Shop.view.backgroundColor = [self randomColor];
    
    UIViewController *UCenter = [[UIViewController alloc] init];
    UINavigationController *UCenterNav = [[UINavigationController alloc]initWithRootViewController:UCenter];
    UCenter.view.backgroundColor = [self randomColor];
    
    
    UIViewController *Activity = [[UIViewController alloc] init];
    UINavigationController * ActivityNav = [[UINavigationController alloc] initWithRootViewController:Activity];
    Activity.view.backgroundColor = [self randomColor];
    
    NSArray *ctrlArr = [NSArray arrayWithObjects:RimNav,RecommendNav,SearchNav,MoreNav,ShopNav,ActivityNav,UCenterNav,More,nil];
    RimNav.title = @"RimNav";
    RecommendNav.title = @"RecommendNav";
    SearchNav.title = @"SearchNav";
    MoreNav.title = @"MoreNav";
    ShopNav.title = @"ShopNav";
    ActivityNav.title = @"ActivityNav";
    UCenterNav.title = @"UCenterNav";
    
    NSArray *imgArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"tab_bar_1"],[UIImage imageNamed:@"tab_bar_2"],[UIImage imageNamed:@"tab_bar_3"],[UIImage imageNamed:@"tab_bar_4"],[UIImage imageNamed:@"tab_bar_5"],[UIImage imageNamed:@"tab_bar_6"],[UIImage imageNamed:@"tab_bar_7"],[UIImage imageNamed:@"tab_bar_4"],nil];
	
	_switchTabBarController = [[SwitchTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
	[_switchTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"mainpage_bottombg"]];
	[_switchTabBarController setTabBarTransparent:YES];
    [self.window addSubview:_switchTabBarController.view];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end
