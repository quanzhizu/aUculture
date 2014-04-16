//
//  ICTapDetectingImageView.h
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICTapDetectingImageViewDelegate;

@interface ICTapDetectingImageView : UIImageView
{
    id<ICTapDetectingImageViewDelegate> tapDelegate;
}
@property (nonatomic, assign) id<ICTapDetectingImageViewDelegate> tapDelegate;

- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;
- (void)handleTripleTap:(UITouch *)touch;

@end


@protocol ICTapDetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;
@end