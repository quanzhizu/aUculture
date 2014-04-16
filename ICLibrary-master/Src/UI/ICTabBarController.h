//
//  ICTabBarController.h
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ICTabBarItem : UITabBarItem
{
	UIImage *CustomHighlightedImage;
}

@property(nonatomic,retain) UIImage *CustomHighlightedImage;

@end


@interface ICTabBarController : UITabBarController
{
    UIImage *TabbarBackgroundImage;
}

@property(nonatomic,retain) UIImage *TabbarBackgroundImage;

@end
