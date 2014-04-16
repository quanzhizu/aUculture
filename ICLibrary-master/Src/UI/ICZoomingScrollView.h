//
//  ICZoomingScrollView.h
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICPhotoProtocol.h"
#import "ICTapDetectingImageView.h"
#import "ICTapDetectingView.h"

@class ICPhotoBrowser, ICPhoto, ICCaptionView;

@interface ICZoomingScrollView : UIScrollView <UIScrollViewDelegate, 
ICTapDetectingImageViewDelegate, ICTapDetectingViewDelegate> 
{
    ICPhotoBrowser *_photoBrowser;                                      /** < 图片浏览器*/
    id<ICPhoto> _photo;                                                 /** < 委托*/
	
    // This view references the related caption view for simplified
    // handling in photo browser
    ICCaptionView *_captionView;                                        /** < 标题*/
    
	ICTapDetectingView *_tapView; // for background taps                /** < 点击背景*/
	ICTapDetectingImageView *_photoImageView;                           /** < 图片*/
	UIActivityIndicatorView *_spinner;                                  /** < 加载中效果*/

}

@property (nonatomic, retain) ICCaptionView *captionView;   
@property (nonatomic, retain) ICTapDetectingImageView *photoImageView;
@property (nonatomic, retain) id<ICPhoto> photo;


- (id)initWithPhotoBrowser:(ICPhotoBrowser *)browser;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;



@end
