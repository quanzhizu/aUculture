//
//  ICPhotoBrowser.h
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ICPhoto.h"
#import "ICPhotoProtocol.h"
#import "ICCaptionView.h"

#if 0 // Set to 1 to enable debug logging
#define ICLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define ICLog(x, ...)
#endif

@class ICPhotoBrowser;

@protocol ICPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(ICPhotoBrowser *)photoBrowser;

//竖屏时的回调
- (id<ICPhoto>)photoBrowser:(ICPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

//横屏时的界面回调
- (id<ICPhoto>)photoBrowserHorizontal:(ICPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;


@optional
- (ICCaptionView *)photoBrowser:(ICPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
@end



@interface ICPhotoBrowser : UIViewController <UIScrollViewDelegate>

// 初始化
- (id)initWithPhotos:(NSArray *)photosArray  __attribute__((deprecated)); // Depreciated
- (id)initWithDelegate:(id <ICPhotoBrowserDelegate>)delegate;

// 重新加载
- (void)reloadData;

// 设置初始化位置
- (void)setInitialPageIndex:(NSUInteger)index;


@end
