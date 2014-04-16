//
//  SwitchTabBar.h
//  switchTabBarDemo
//
//  Created by  张培川 on 13-8-1.
//  Copyright (c) 2013年 张培川. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwitchTabBarDelegate;

@interface SwitchTabBar : UIView
{
    NSMutableArray  *_buttons;
    UIImageView     *backgroundImage;
    UIImageView     *downImageView;
    id<SwitchTabBarDelegate> _delegate;
    int             currentSelectButton;
}
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, assign) id<SwitchTabBarDelegate> delegate;
- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)setBackgroundImage:(UIImage *)img;
- (void)selectTabAtIndex:(NSInteger)index;
@end
@protocol SwitchTabBarDelegate<NSObject>
@optional
- (void)tabBar:(SwitchTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
