//
//  DefaultGoodsView.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-11.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "DefaultGoodsView.h"

@implementation DefaultGoodsView
@synthesize titileImageView,titleLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLable =[UILabel new];
    }
    return self;
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



@implementation SingleGoodSView
@synthesize nameLable,priceLable,titileImageView,nameLable_height;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.nameLable = [UILabel new];
        self.priceLable = [UILabel new];
        self.titileImageView = [UIImageView new];
        
        [self addSubview:nameLable];
        [self addSubview:priceLable];
        [self addSubview:titileImageView];
        
        self.nameLable.numberOfLines = 0;
        self.nameLable.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.nameLable.translatesAutoresizingMaskIntoConstraints = NO;
        self.priceLable.translatesAutoresizingMaskIntoConstraints = NO;
        self.titileImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *nameLable_horizontal_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5.0-[nameLable]-5.0-[titileImageView(50)]-5.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nameLable,titileImageView)];
        
        NSArray *nameLable_vertical_contrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.0-[nameLable]-1.0-[priceLable]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(nameLable,priceLable)];
       self.nameLable_height = [NSLayoutConstraint constraintWithItem:nameLable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
        [self addConstraints:nameLable_horizontal_contrains];
        [self addConstraints:nameLable_vertical_contrains];
        [self addConstraint:nameLable_height];
        
        
        NSLayoutConstraint *priceLable_width = [NSLayoutConstraint constraintWithItem:priceLable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nameLable attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [self addConstraint:priceLable_width];
        
        
         NSLayoutConstraint *titileImageView_height = [NSLayoutConstraint constraintWithItem:titileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0];
        [self addConstraint:titileImageView_height];
        
    }
    return self;
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
