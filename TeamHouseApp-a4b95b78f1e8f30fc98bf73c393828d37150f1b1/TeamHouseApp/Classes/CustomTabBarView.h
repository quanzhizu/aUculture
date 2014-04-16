//
//  CustomTabBarView.h
//  TeamHouseApp
//
//  Created by 李仁兵 on 14-1-7.
//  Copyright (c) 2014年 liu faliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarViewDelegate <NSObject>
@required
- (void)touchBtn:(NSInteger)btnTag;
@end

@interface CustomTabBarView : UIView
{
    id<CustomTabBarViewDelegate> _delegate;
}
@property (nonatomic) NSInteger numberOfController;
@property (nonatomic,strong) id<CustomTabBarViewDelegate>delegate;
@end


