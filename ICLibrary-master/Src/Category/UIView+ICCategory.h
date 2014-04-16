//
//  UIView+ICCategory.h
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ICCategory)

//frame
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;


-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)class;

@end
