//
//  UIImageView+ICCategory.h
//  WhiteBook2
//
//  Created by Fox on 13-2-25.
//  Copyright (c) 2013年 c1618. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CommonHelper.h"

@interface UIImageView (ICCategory)

- (void)setImageWithURL:(NSURL *)url inRect:(CGRect )rect;

@end
