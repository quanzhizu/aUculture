//
//  ICLabel.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface ICLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
