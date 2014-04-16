//
//  ICZoomableImageView.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICZoomableImageView.h"

@implementation ICZoomableImageView
@synthesize imageView;
@synthesize zoomableImageDelegate = _zoomableImageDelegate;

#pragma mark - Memory manager
-(void)dealloc
{
    [imageView release];
    [super dealloc];
}

#pragma mark - View life cycle
- (id)initwithImage:(UIImage *)image frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //scrollview property
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 3.0;
        [self setZoomScale:1.0];
        
        //imageview really size
        float xRatio = image.size.width / frame.size.width;
        float yRatio = image.size.height / frame.size.height;
        float ratio = MAX(xRatio, yRatio);
        CGSize realImageViewSize = CGSizeMake(image.size.width / ratio, image.size.height/ratio);
        
        //imageview
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, realImageViewSize.width, realImageViewSize.height);
        [self centerScrollViewContents];
        imageView.userInteractionEnabled = YES;
        
        //add double tap gesture
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [imageView addGestureRecognizer:doubleTap];
        [doubleTap release];
        
        //add single tap gesture
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [singleTap release];
        
        self.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
        [self addSubview:imageView];
    }
    
    return self;
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //每次放大缩小后，都需要调整imageView坐标，否则显示不正常
    [self centerScrollViewContents];
}

#pragma mark -
- (void)handleSingleTap:(UIGestureRecognizer *)gesture
{
    if (_zoomableImageDelegate != nil  && [_zoomableImageDelegate respondsToSelector:@selector(zoomableImageViewonSingleTap:singleTap:)]) {
        [_zoomableImageDelegate zoomableImageViewonSingleTap:self singleTap:gesture];
    }
    
}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    //双击操作，如果不是最小缩放，就缩小，否则就放大
    float newScale;
    if(self.zoomScale==1.0){
        newScale = self.maximumZoomScale;
    } else{
        newScale = self.minimumZoomScale;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:self withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
    
    if (_zoomableImageDelegate != nil && [_zoomableImageDelegate respondsToSelector:@selector(zoomableImageViewonDoubleTap:doubleTap:)]) {
        [_zoomableImageDelegate zoomableImageViewonDoubleTap:self doubleTap:gesture];
    }
    
}

#pragma mark - Utility methods
-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
//计算imageView中心放大区域    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


- (void)centerScrollViewContents {
    //调整变化大小后imageView的位置
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageView.frame = contentsFrame;
}

- (void) resizeToBase:(BOOL) animate
{
    //还原imageView大小
    if(self.zoomScale!=self.minimumZoomScale)
    {
        CGRect zoomRect = [self zoomRectForScale:self.minimumZoomScale  inView:self withCenter:CGPointMake(181.5,43)];
        [self zoomToRect:zoomRect animated:animate];
    }
    
}





@end
