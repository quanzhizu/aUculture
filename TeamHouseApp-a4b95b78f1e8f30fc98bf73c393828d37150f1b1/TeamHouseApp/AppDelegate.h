//
//  AppDelegate.h
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-23.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKMapViewDelegate>
{
    BMKMapManager* _mapManager;
    BMKMapView *myMapView;
}
@property (strong, nonatomic) UIWindow *window;

@end
