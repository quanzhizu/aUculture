//
//  SwitchTabBar.m
//  switchTabBarDemo
//
//  Created by 张培川 on 13-8-1.
//  Copyright (c) 2013年 张培川. All rights reserved.
//

#import "SwitchTabBar.h"
static const int TABS_PER_ROW = 4;
static const int MORE_BUTTON_INDEX = 3;
static const int TAB_Btn_Height = 45;

@implementation SwitchTabBar
@synthesize buttons = _buttons;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];

		backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
		[self addSubview:backgroundImage];
        [self addSubview:downImageView];
        
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
		CGFloat width = 320.0f / TABS_PER_ROW;
		for (int i = 0; i < [imageArray count]; i++)
		{
            NSInteger index = i % TABS_PER_ROW;
            NSInteger page = i / TABS_PER_ROW;
            
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i;
			btn.frame = CGRectMake(width * index , page*frame.size.height +5, width, TAB_Btn_Height);
			[btn setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
			[btn setImage:[imageArray objectAtIndex:i] forState:UIControlStateSelected];
            
			[btn setBackgroundImage:[UIImage imageNamed:@"tab_bar_selected"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"tab_bar_selected"] forState:UIControlStateHighlighted];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.buttons addObject:btn];
            [self addSubview:btn];
		}
    }
    return self;
}
- (void)setBackgroundImage:(UIImage *)img
{
	[backgroundImage setImage:img];
    [downImageView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
}
- (void)selectTabAtIndex:(NSInteger)index
{
    if (index == MORE_BUTTON_INDEX) {
        [self down];
    }else if (index == [self.buttons count]-1) {
        [self up];
    }else{
        //当有些模块，需要登录或者其他支持时，需要单独在对应的按钮进行处理
//        Config *config = [Config Instance];
//        if (index == 5 && config.isCookie == NO) {
//            UIButton *btn = [self.buttons objectAtIndex:index];
//            if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
//            {
//                [_delegate tabBar:self didSelectIndex:btn.tag];
//            }
//            return;
//        }
        for (int i = 0; i < [self.buttons count]; i++)
        {
            UIButton *b = [self.buttons objectAtIndex:i];
            b.selected = NO;
        }
        UIButton *btn = [self.buttons objectAtIndex:index];
        btn.selected = YES;
        currentSelectButton = index;
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
        {
            [_delegate tabBar:self didSelectIndex:btn.tag];
        }
        NSLog(@"Select index: %d",btn.tag);
    }
}
- (void)dealloc
{
    [_buttons release];
    [super dealloc];
}
//向下动画
-(void)down{
    if (currentSelectButton < 4) {
        UIButton *button = [self.buttons objectAtIndex:currentSelectButton];
        button.selected = NO;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    for (int i = 0 ; i < [self.buttons count]; i ++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if (i < TABS_PER_ROW) {
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height, button.frame.size.width, button.frame.size.height);
        }else{
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y -5 - button.frame.size.height, button.frame.size.width, button.frame.size.height);
        }
    }
    backgroundImage.frame = CGRectMake(0, backgroundImage.frame.origin.y + backgroundImage.frame.size.height, backgroundImage.frame.size.width, backgroundImage.frame.size.height);
    downImageView.frame = CGRectMake(0, 0, downImageView.frame.size.width, downImageView.frame.size.height);
    [UIView commitAnimations];

}
//向上动画
-(void)up{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    for (int i = 0 ; i < [self.buttons count]; i ++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if (i < TABS_PER_ROW) {
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y - button.frame.size.height, button.frame.size.width, button.frame.size.height);
        }else{
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y +5 + button.frame.size.height, button.frame.size.width, button.frame.size.height);
        }
    }
    backgroundImage.frame = CGRectMake(0, backgroundImage.frame.origin.y - backgroundImage.frame.size.height, backgroundImage.frame.size.width, backgroundImage.frame.size.height);
    downImageView.frame = CGRectMake(0, downImageView.frame.size.height, downImageView.frame.size.width, downImageView.frame.size.height);
    [UIView setAnimationDelegate:self];
    //动画执行完毕后的操作
    [UIView setAnimationDidStopSelector:@selector(hidenButton)];
    [UIView commitAnimations];
}
-(void)hidenButton
{
    if (currentSelectButton < 4) {
        UIButton *button = [self.buttons objectAtIndex:currentSelectButton];
        button.selected = YES;
    }
}
@end
