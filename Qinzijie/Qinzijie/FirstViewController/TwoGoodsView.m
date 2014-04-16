//
//  TwoGoodsView.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-11.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "TwoGoodsView.h"

@implementation TwoGoodsView
@synthesize goodsImageView,priceImageView,priceLable,activityImageView,activityLable,btn,btnPress,goodsImageViewUrl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.goodsImageViewUrl = @"";
        self.goodsImageView = [[UIImageView alloc] init];
        self.priceImageView = [[UIImageView alloc] init];
        self.activityImageView = [[UIImageView alloc] init];
        self.priceLable = [UILabel new];
        self.activityLable = [UILabel new];
        self.btn = [UIButton new];
        
        self.userInteractionEnabled = YES;
        self.priceImageView.userInteractionEnabled = YES;
        self.goodsImageView.userInteractionEnabled = YES;
        self.activityImageView.userInteractionEnabled = YES;
        
        
        self.goodsImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.priceImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.priceLable.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityLable.translatesAutoresizingMaskIntoConstraints = NO;
        self.btn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.goodsImageView];
        [self addSubview:self.priceImageView];
        [self addSubview:self.priceLable];
        [self addSubview:self.activityImageView];
        [self.activityImageView addSubview:self.activityLable];
        [self addSubview:self.btn];
        
        priceLable.numberOfLines = 0; //will wrap text in new line
        [priceLable sizeToFit];
        
        UIImage *image = [UIImage imageNamed:@"N输入框1.png"];
        self.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        self.goodsImageView.backgroundColor = [UIColor orangeColor];
        self.priceImageView.backgroundColor = [UIColor clearColor];
        self.priceLable.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.6];
        self.priceLable.textColor = [UIColor whiteColor];
        self.activityImageView.backgroundColor = [UIColor orangeColor];
        self.activityLable.backgroundColor = [UIColor clearColor];
        self.activityLable.textColor = [UIColor whiteColor];
        self.priceLable.textAlignment = NSTextAlignmentCenter;
        self.activityLable.textAlignment = NSTextAlignmentCenter;
        
        self.priceLable.font = [UIFont boldSystemFontOfSize:14.0];
        self.activityLable.font = [UIFont systemFontOfSize:14.0];
        
        
        //goodsImageView position
        NSArray *goodsImageView_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25.0-[goodsImageView]-25.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(goodsImageView)];
        NSArray *goodsImageView_veritical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10.0-[goodsImageView]-10.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(goodsImageView)];
        [self addConstraints:goodsImageView_horizontal_contrains];
        [self addConstraints:goodsImageView_veritical_contrains];
        
        
        //priceImageView 位置
        NSArray *priceImageView_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.0-[priceImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(priceImageView)];
        NSArray *priceImageView_veritical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[priceImageView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(priceImageView)];
        NSLayoutConstraint *priceImageView_width = [NSLayoutConstraint constraintWithItem:priceImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        [self addConstraints:priceImageView_horizontal_contrains];
        [self addConstraints:priceImageView_veritical_contrains];
        [self addConstraint:priceImageView_width];
        
        
        NSArray *priceLable_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.0-[priceLable]-0.0-[activityImageView(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(priceLable,activityImageView)];
        NSArray *priceLable_veritical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[priceLable(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(priceLable)];
        NSLayoutConstraint *priceLable_width = [NSLayoutConstraint constraintWithItem:priceLable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0];
        [self addConstraints:priceLable_horizontal_contrains];
        [self addConstraints:priceLable_veritical_contrains];
        [self addConstraint:priceLable_width];
        
        
      
        NSLayoutConstraint *activityImageView_aligin = [NSLayoutConstraint constraintWithItem:activityImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:priceImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *activityImageView_width = [NSLayoutConstraint constraintWithItem:activityImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self addConstraint:activityImageView_aligin];
        [self addConstraint:activityImageView_width];
        
        
        NSArray *activityLable_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5.0-[activityLable]-5.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(activityLable)];
        NSArray *activityLable_veritical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.0-[activityLable]-5.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(activityLable)];
        
        [self addConstraints:activityLable_horizontal_contrains];
        [self addConstraints:activityLable_veritical_contrains];
        
        NSArray *btn_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5.0-[btn]-5.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
        NSArray *btn_veritical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.0-[btn]-5.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addConstraints:btn_horizontal_contrains];
        [self addConstraints:btn_veritical_contrains];
        
    }
    return self;
}

-(void)btnAction:(UIButton *)sender{
    NSLog( @"btn action");
    if (btnPress) {
        btnPress(self);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
