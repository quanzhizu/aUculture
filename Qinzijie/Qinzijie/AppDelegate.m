//
//  AppDelegate.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;
    return YES;
}



#pragma mark - Methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[FirstViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[SecondViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[ThirdViewController alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:thirdViewController];
    thirdNavigationController.delegate = (id)self;
    
    
    UIViewController *fourViewController = [[FourViewController alloc] init];
    UINavigationController *fourNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:fourViewController];
    fourNavigationController.delegate = (id)self;
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,fourNavigationController]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third",@""];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    RDVTabBarController *rdv = (RDVTabBarController *)self.viewController;
    [rdv setTabBarHidden:NO animated:YES];
}
- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_tall"]
                                      forBarMetrics:UIBarMetricsDefault];
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"]
                                      forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *textAttributes = nil;
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
            textAttributes = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               };
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            textAttributes = @{
                               UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                               UITextAttributeTextColor: [UIColor blackColor],
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                               };
#endif
        }
        
        [navigationBarAppearance setTitleTextAttributes:textAttributes];
    }
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

@end
