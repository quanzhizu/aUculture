//
//  GoodsCell.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "GoodsCell.h"

@interface GoodsCell ()

@end

@implementation GoodsCell
@synthesize mainScorllView,leftGoodsView,rightGoodsView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:DTYPE_DEFAULT]) {
            
            
        }else if([reuseIdentifier isEqualToString:DTYPE_TWO]){
            
            self.leftGoodsView = [[TwoGoodsView alloc] initWithFrame:CGRectMake(10, 5, 140, 140)];
            [self addSubview:leftGoodsView];
            
            self.rightGoodsView = [[TwoGoodsView alloc] initWithFrame:CGRectMake(165, 5, 140, 140)];
            [self addSubview:rightGoodsView];
            
        }else if([reuseIdentifier isEqualToString:DTYPE_SCTROLL]){
            
            NSMutableArray *viewsArray = [@[] mutableCopy];
            NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
            for (int i = 0; i < 5; ++i) {
                 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
                imageView.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
                [viewsArray addObject:imageView];
                
            }
            self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150) animationDuration:2];
            self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
            self.mainScorllView.allContentViews = viewsArray;
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return 5;
            };
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                NSLog(@"点击了第%d个",pageIndex);
            };
            [self addSubview:self.mainScorllView];
        }
    }
    return self;
}
@end
