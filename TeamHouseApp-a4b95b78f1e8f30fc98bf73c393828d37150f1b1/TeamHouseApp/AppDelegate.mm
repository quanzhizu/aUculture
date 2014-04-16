//
//  AppDelegate.m
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-23.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "LoadViewController.h"
#import "PortTestViewController.h"
#import "CustomTabBarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //地图定位
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
	BOOL ret = [_mapManager start:@"9F69A35F7A9C64D6172E3566B6BCC9C7FB7EABF7" generalDelegate:nil];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    myMapView = [[BMKMapView alloc] init];
    myMapView.delegate = self;
    [myMapView setShowsUserLocation:YES];

    PortTestViewController *portView = [[PortTestViewController alloc]initWithNibName:@"PortTestViewController" bundle:nil];
    CustomNavigationController *Nav = [[CustomNavigationController alloc]initWithRootViewController:portView];
    
    NSArray * array = [NSArray arrayWithObjects:Nav, nil];
    CustomTabBarViewController * tabBarVC = [[CustomTabBarViewController alloc] init];
    tabBarVC.controllers = array;
    [tabBarVC hidenTabBarAndCustomBar:YES];
    self.window.rootViewController = tabBarVC;
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;

}



#pragma mark - BMKMapView定位代理
-(void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"开始定位");
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    
    [mapView setShowsUserLocation:NO];
    
    NSLog(@"经纬度%f  %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude );
    
    
}

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    [mapView setShowsUserLocation:NO];
}

-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    NSLog(@"定位结束");
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
