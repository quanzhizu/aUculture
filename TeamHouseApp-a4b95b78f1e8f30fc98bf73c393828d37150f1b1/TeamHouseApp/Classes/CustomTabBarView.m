//
//  CustomTabBarView.m
//  TeamHouseApp
//
//  Created by 李仁兵 on 14-1-7.
//  Copyright (c) 2014年 liu faliang. All rights reserved.
//

#import "CustomTabBarView.h"

@interface CustomTabBarView()
{
    UIImageView * backImageView;
}

@end

@implementation CustomTabBarView
@synthesize numberOfController;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_OFFSET)];
        backImageView.image = [UIImage imageNamed:@"tabBarBackImage_Cn"];
        backImageView.userInteractionEnabled = YES;
        [self addSubview:backImageView];
            }
    return self;
}

- (void)setNumberOfController:(NSInteger)_numberOfController
{
    for (int i= 0;i<_numberOfController;i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(i*(320.0/_numberOfController), 0, 320.0/_numberOfController, 55.5);
        [btn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
    }
}

- (void)touch:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(touchBtn:)]) {
        [_delegate touchBtn:btn.tag];
    }
}
@end
