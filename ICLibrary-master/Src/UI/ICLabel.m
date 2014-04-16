//
//  ICLabel.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICLabel.h"

@implementation ICLabel
@synthesize verticalAlignment = _verticalAlignment;


#pragma mark - Memory manager
-(void)dealloc
{
    [super dealloc];
}


#pragma mark - UIView  life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认为居中
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment 
{
    //设置布局方式
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines 
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}


-(void)drawTextInRect:(CGRect)requestedRect 
{
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
