//
//  ICZoomableImageView.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICZoomableImageViewDelegate;

@interface ICZoomableImageView : UIScrollView <UIScrollViewDelegate>
{
    id<ICZoomableImageViewDelegate> _zoomableImageDelegate;
}


@property (nonatomic, assign) id<ICZoomableImageViewDelegate> zoomableImageDelegate;
@property (nonatomic, retain) UIImageView *imageView;


- (id)initwithImage:(UIImage *)image frame:(CGRect) frame;
- (void)resizeToBase:(BOOL) animate;

- (CGRect)zoomRectForScale:(float) scale inView:(UIScrollView *)scrollView withCenter:(CGPoint)center;
- (void)centerScrollViewContents;

@end


@protocol ICZoomableImageViewDelegate <NSObject>

@optional

//single and  double tap gesture
- (void) zoomableImageViewonSingleTap:(ICZoomableImageView *)zoomableImageView singleTap:(UIGestureRecognizer *) gesture;
- (void) zoomableImageViewonDoubleTap:(ICZoomableImageView *)zoomableImageView doubleTap:(UIGestureRecognizer *) gesture;


@end
