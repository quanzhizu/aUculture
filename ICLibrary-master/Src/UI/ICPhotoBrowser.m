//
//  ICPhotoBrowser.m
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ICPhotoBrowser.h"
#import "ICZoomingScrollView.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define PADDING                 10
#define PAGE_INDEX_TAG_OFFSET   1000
#define PAGE_INDEX(page)        ([(page) tag] - PAGE_INDEX_TAG_OFFSET)

#define ReadViewTitleFrame      CGRectMake(0,20, 768,42)
#define ReadViewTitleFrameH     CGRectMake(0,20, 1024,42)
#define BackButtonFrame CGRectMake(24, 27, 55, 28)
#define ChapterButtonFrame      CGRectMake(689, 27, 55, 28)
#define ChapterButtonFrame2     CGRectMake(950, 27, 55, 28)
#define ReadScrollViewFrame CGRectMake(130,87,508,656)
#define TitleLableFrame CGRectMake(300, 20, 168, 42)

#define MYCHAPTERPOPVIEW    987


@interface ICPhotoBrowser ()
{
    // Data
    id <ICPhotoBrowserDelegate> _delegate;                  /** < 代理*/
    NSUInteger _photoCount;                                 /** < 数目*/
    NSUInteger _photoCountHorizontal;                       /** < 横屏页面数目*/
    
    NSMutableArray *_photos;                                /** < 杂志页面*/
	NSArray *_depreciatedPhotoData; // Depreciated          /** < 已经过期的杂志数据*/
	
	// Views
	UIScrollView *_pagingScrollView;                        /** < 总的页面scroll*/
	
	// Paging
	NSMutableSet *_visiblePages, *_recycledPages;           /** < 可见的页面和循环利用的页面*/
	NSUInteger _currentPageIndex;                           /** < 当前页面的位置*/
	NSUInteger _pageIndexBeforeRotation;                    /** < 旋转之前的页面位置*/
	
	// Navigation & controls
	NSTimer *_controlVisibilityTimer;                       /** < 控制页面控件是否可见*/
    
    // Misc
	BOOL _performingLayout;                                 /** < 是否布局*/
	BOOL _rotating;                                         /** < 是否选装*/
    BOOL _viewIsActive; // active as in it's in the view heirarchy
    
    //title
    UIImageView *titleBack;     /** < 上方标题背景*/
    UILabel *title;             /** < 标题*/
    UIButton *backBtn;          /** < 返回按钮*/
    UIButton *chapterBtn;       /** < 章节按钮*/
    
    UIInterfaceOrientation oldInterfaceOrientation;
}

/**
 * @brief   执行布局
 */
- (void)performLayout;

/**
 * @brief   初始化标题
 */
- (void)initTitleView;

/**
 * @brief   点击返回按钮
 */
- (void)clickBackButton:(id)sender;

/**
 * @brief   显示和隐藏导航
 */
- (void)showAndHideWidget;

/**
 * @brief   设置页面
 */
- (void)tilePages;

/**
 * @brief   index是否存在页面
 */
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

/**
 * @brief   index位置的页面
 */
- (ICZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index;

/**
 * @brief   生成放大缩小的页面
 */
- (ICZoomingScrollView *)pageDisplayingPhoto:(id<ICPhoto>)photo;

/**
 * @brief   循环使用页面
 */
- (ICZoomingScrollView *)dequeueRecycledPage;

/**
 * @brief   设置对应的页面
 */
- (void)configurePage:(ICZoomingScrollView *)page forIndex:(NSUInteger)index;

/**
 * @brief   开始展示第index的页面
 */
- (void)didStartViewingPageAtIndex:(NSUInteger)index;


// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;

// Navigation
- (void)jumpToPageAtIndex:(NSUInteger)index;
- (BOOL)pageIsHorizontal;

// Controls
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent;
- (void)toggleControls;
- (BOOL)areControlsHidden;

// Data
- (NSUInteger)numberOfPhotos;
- (id<ICPhoto>)photoAtIndex:(NSUInteger)index;
- (UIImage *)imageForPhoto:(id<ICPhoto>)photo;
- (void)loadAdjacentPhotosIfNecessary:(id<ICPhoto>)photo;
- (void)releaseAllUnderlyingPhotos;

@end

// Handle depreciations and supress hide warnings
@interface UIApplication (DepreciationWarningSuppresion)
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@implementation ICPhotoBrowser
#pragma mark - Memory manager
// Release any retained subviews of the main view.
- (void)viewDidUnload {
	_currentPageIndex = 0;
    [_pagingScrollView release], _pagingScrollView = nil;
    [_visiblePages release], _visiblePages = nil;
    [_recycledPages release], _recycledPages = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[_pagingScrollView release];
	[_visiblePages release];
	[_recycledPages release];
  	[_depreciatedPhotoData release];
    [titleBack release];
    [title release];
    [self releaseAllUnderlyingPhotos];
    [[SDImageCache sharedImageCache] clearMemory]; // clear memory
    [_photos release];
    [super dealloc];
}

- (void)releaseAllUnderlyingPhotos {
    for (id p in _photos)
    { if (p != [NSNull null])
        [p unloadUnderlyingImage];
    }
    
}

- (void)didReceiveMemoryWarning {
	
	// Release any cached data, images, etc that aren't in use.
    [self releaseAllUnderlyingPhotos];
	[_recycledPages removeAllObjects];
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

#pragma mark - NSObject init
- (id)init {
    if ((self = [super init])) {
        
        // Defaults
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
        _photoCount = NSNotFound;
        _photoCount = NSNotFound;
		_currentPageIndex = 0;
		_performingLayout = NO; // Reset on view did appear
		_rotating = NO;
        _viewIsActive = NO;
        _visiblePages = [[NSMutableSet alloc] init];
        _recycledPages = [[NSMutableSet alloc] init];
        
        _photos = [[NSMutableArray alloc] init];
        
        oldInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        // Listen for ICPhoto notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleICPhotoLoadingDidEndNotification:)
                                                     name:ICPHOTO_LOADING_DID_END_NOTIFICATION
                                                   object:nil];
    }
    return self;
}

- (id)initWithDelegate:(id <ICPhotoBrowserDelegate>)delegate {
    if ((self = [self init])) {
        _delegate = delegate;
	}
	return self;
}

- (id)initWithPhotos:(NSArray *)photosArray {
	if ((self = [self init])) {
		_depreciatedPhotoData = [photosArray retain];
	}
	return self;
}

- (void)setInitialPageIndex:(NSUInteger)index {
    // Validate
    if (index >= [self numberOfPhotos]) index = [self numberOfPhotos]-1;
    _currentPageIndex = index;
	if ([self isViewLoaded]) {
        [self jumpToPageAtIndex:index];
        if (!_viewIsActive)
            [self tilePages];
        // Force tiling if view is not visible
    }
}


#pragma mark - View Loading
- (void)viewDidLoad {
	
	// View
	self.view.backgroundColor = [UIColor clearColor];
	
    //阅读背景
    UIImageView *readBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    readBackground.image = [UIImage imageNamed:@"readViewBack.png"];
    [self.view addSubview:readBackground];
    [readBackground release];
    
	// Setup paging scrolling view
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	_pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	_pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_pagingScrollView.pagingEnabled = YES;
	_pagingScrollView.delegate = self;
	_pagingScrollView.showsHorizontalScrollIndicator = NO;
	_pagingScrollView.showsVerticalScrollIndicator = NO;
	_pagingScrollView.backgroundColor = [UIColor clearColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	[self.view addSubview:_pagingScrollView];
    

    
    //初始化标题
    [self initTitleView];
    
    [self reloadData];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewIsActive = YES;
}

- (void)performLayout {
    
    // Setup
    _performingLayout = YES;
    
	// Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    [self tilePages];
    
    _performingLayout = NO;
    
}


#pragma mark - Layout
- (void)viewWillLayoutSubviews {
    
    // Super
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) [super viewWillLayoutSubviews];
	
	// Flag
	_performingLayout = YES;
	
	// 记录当前位置
	NSUInteger indexPriorToLayout = _currentPageIndex;
	
	// 调整scrollview的frame
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	_pagingScrollView.frame = pagingScrollViewFrame;
	// Recalculate contentSize based on current orientation
	_pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    for (ICZoomingScrollView *page in _visiblePages) {
        NSUInteger index = PAGE_INDEX(page);
        page.frame = [self frameForPageAtIndex:index];
        [page setMaxMinZoomScalesForCurrentBounds];
        
    }
    
    // Adjust contentOffset to preserve page location based on values collected prior to location
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
    
    
    
	[self didStartViewingPageAtIndex:_currentPageIndex]; // initial
    
	// Reset
	_currentPageIndex = indexPriorToLayout;
	
    
    //调增下方导航栏和下方目录
    UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        
    
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
    
    }
    
    
    _performingLayout = NO;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    //支持各个方向的选装
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //将要旋转
	_pageIndexBeforeRotation = _currentPageIndex;
    
    //记录当前方向
    oldInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	_rotating = YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	// Perform layout
	_currentPageIndex = _pageIndexBeforeRotation;
    
	// Layout manually (iOS < 5)
    if (SYSTEM_VERSION_LESS_THAN(@"5")) [self viewWillLayoutSubviews];
	
	// Delay control holding
	[self hideControlsAfterDelay];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	_rotating = NO;
}

#pragma mark - Data
- (void)reloadData {
    //重新加载数据
    
    // Reset
    _photoCount = NSNotFound;
    _photoCountHorizontal = NSNotFound;
    
    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    
    //释放所有图片
    [self releaseAllUnderlyingPhotos];
    [_photos removeAllObjects];
    
    //初始化视图
    for (int i = 0; i < numberOfPhotos; i++)
    {
        [_photos addObject:[NSNull null]];
    }
    
    // 更新界面
    [self performLayout];
    
    // Layout
    if (SYSTEM_VERSION_LESS_THAN(@"5"))
        [self viewWillLayoutSubviews];
    else
        [self.view setNeedsLayout];
    
}

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
        } else if (_depreciatedPhotoData) {
            _photoCount = _depreciatedPhotoData.count;
        }
    }
    
    if (_photoCount == NSNotFound)
    {
        _photoCount = 0;
        _photoCountHorizontal = 0;
    }
    return _photoCount;
}

- (id<ICPhoto>)photoAtIndex:(NSUInteger)index {
    id <ICPhoto> photo = nil;
    
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
                photo = [_delegate photoBrowser:self photoAtIndex:index];
            } else if (_depreciatedPhotoData && index < _depreciatedPhotoData.count) {
                photo = [_depreciatedPhotoData objectAtIndex:index];
            }
            if (photo) [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    
    return photo;
}

- (UIImage *)imageForPhoto:(id<ICPhoto>)photo {
	if (photo) {
		// Get image or obtain in background
		if ([photo underlyingImage]) {
			return [photo underlyingImage];
		} else {
            [photo loadUnderlyingImageAndNotify];
		}
	}
	return nil;
}

- (void)loadAdjacentPhotosIfNecessary:(id<ICPhoto>)photo {
    ICZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        // If page is current page then initiate loading of previous and next pages
        NSUInteger pageIndex = PAGE_INDEX(page);
        if (_currentPageIndex == pageIndex) {
            if (pageIndex > 0) {
                // Preload index - 1
                id <ICPhoto> photo = [self photoAtIndex:pageIndex-1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                }
            }
            if (pageIndex < [self numberOfPhotos] - 1) {
                // Preload index + 1
                id <ICPhoto> photo = [self photoAtIndex:pageIndex+1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    ICLog(@"Pre-loading image at index %i", pageIndex+1);
                }
            }
        }
    }
}



-(void)initTitleView
{
    //标题栏背景
    titleBack = [[UIImageView alloc] init];
    titleBack.image = [UIImage imageNamed:@"main_title_back"];
    titleBack.hidden = NO;
    [self.view addSubview:titleBack];
    
    
    //设置标题
    title = [[UILabel alloc]initWithFrame:TitleLableFrame];
    title.textColor=[UIColor whiteColor];
    title.textAlignment=UITextAlignmentCenter;
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    
    //标题栏返回按钮
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"readViewBackBtn.png"] forState:UIControlStateNormal];
    backBtn.tag=1;
    [backBtn addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backBtn];
    
    //章节按钮
    chapterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chapterBtn setImage:[UIImage imageNamed:@"readViewChapterBtn"] forState:UIControlStateNormal];
    chapterBtn.tag=2;
    [chapterBtn setFrame:ChapterButtonFrame];
    [chapterBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:chapterBtn];
}

- (void)clickBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ICPhoto Loading Notification

- (void)handleICPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <ICPhoto> photo = [notification object];
    ICZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        if ([photo underlyingImage]) {
            // Successful load
            [page displayImage];
            [self loadAdjacentPhotosIfNecessary:photo];
        } else {
            // Failed to load
            [page displayImageFailure];
        }
    }
}

#pragma mark - Paging
- (void)tilePages {
    
    //计算出第一个和最后一个的位置
	// Calculate which pages should be visible
	// Ignore padding as paging bounces encroach on that
	// and lead to false page loads
	CGRect visibleBounds = _pagingScrollView.bounds;
	int iFirstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
	int iLastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > [self numberOfPhotos] - 1)
        iFirstIndex = [self numberOfPhotos] - 1;
    if (iLastIndex < 0)
        iLastIndex = 0;
    if (iLastIndex > [self numberOfPhotos] - 1)
        iLastIndex = [self numberOfPhotos] - 1;
	
    //循环使用不在需要的页面
	// Recycle no longer needed pages
    NSInteger pageIndex;
	for (ICZoomingScrollView *page in _visiblePages) {
        pageIndex = PAGE_INDEX(page);
		if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
			[_recycledPages addObject:page];
            [page prepareForReuse];
			[page removeFromSuperview];
		}
	}
    
	[_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
	// Add missing pages
	for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
            // Add new page
			ICZoomingScrollView *page = [self dequeueRecycledPage];
			if (!page) {
				page = [[[ICZoomingScrollView alloc] initWithPhotoBrowser:(ICPhotoBrowser *)self] autorelease];
			}
			[self configurePage:page forIndex:index];
			[_visiblePages addObject:page];
			[_pagingScrollView addSubview:page];
            
		}
	}
	
}


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    
    for (ICZoomingScrollView *page in _visiblePages)
        if (PAGE_INDEX(page) == index) return YES;
	return NO;
}

- (ICZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
	ICZoomingScrollView *thePage = nil;
	for (ICZoomingScrollView *page in _visiblePages) {
		if (PAGE_INDEX(page) == index) {
			thePage = page; break;
		}
	}
    
	return thePage;
}

- (ICZoomingScrollView *)pageDisplayingPhoto:(id<ICPhoto>)photo {
	ICZoomingScrollView *thePage = nil;
    
    for (ICZoomingScrollView *page in _visiblePages) {
        if (page.photo == photo) {
            thePage = page; break;
        }
    }
    return thePage;
    
    
}

- (void)configurePage:(ICZoomingScrollView *)page forIndex:(NSUInteger)index {
    
    page.frame = [self frameForPageAtIndex:index];
    page.tag = PAGE_INDEX_TAG_OFFSET + index;
    page.photo = [self photoAtIndex:index];
}

- (ICZoomingScrollView *)dequeueRecycledPage {
    
	ICZoomingScrollView *page;
    
    page = [_recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [_recycledPages removeObject:page];
    }
    
	return page;
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    
    // Release images further away than +/-1
    NSUInteger i;
    if (index > 0) {
        // Release anything < index - 1
        for (i = 0; i < index-1; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                ICLog(@"Released underlying image at index %i", i);
            }
        }
    }
    if (index < [self numberOfPhotos] - 1) {
        // Release anything > index + 1
        for (i = index + 2; i < _photos.count; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                ICLog(@"Released underlying image at index %i", i);
            }
        }
    }
    
    
    // Load adjacent images if needed and the photo is already
    // loaded. Also called after photo has been loaded in background
    id <ICPhoto> currentPhoto = [self photoAtIndex:index];
    if ([currentPhoto underlyingImage]) {
        // photo loaded so load ajacent now
        [self loadAdjacentPhotosIfNecessary:currentPhoto];
    }
    
}

#pragma mark - Frame Calculations
- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    
    return pageFrame;
}


- (CGRect)frameForIndexTable
{
    CGRect frame = self.view.bounds;
    
    frame.origin.y = self.view.bounds.size.height - frame.size.height + 20;
    
    return frame;
}

- (CGSize)contentSizeForPagingScrollView {
    
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
	CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}

- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
	return CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height);
}

#pragma mark - Navigation
- (void)jumpToPageAtIndex:(NSUInteger)index {
	
	// Change page
	if (index < [self numberOfPhotos]) {
		CGRect pageFrame = [self frameForPageAtIndex:index];
		_pagingScrollView.contentOffset = CGPointMake(pageFrame.origin.x - PADDING, 0);
	}
	
	// Update timer to give more time
	[self hideControlsAfterDelay];
	
}


- (BOOL)pageIsHorizontal
{
    //判断页面是否为横屏
    UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        return NO;
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        return YES;
    }
    return NO;
}

#pragma mark - Control Hiding / Showing
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    
    // Cancel any timers
    [self cancelControlHiding];
	
    
    // Captions
    NSMutableSet *captionViews = [[[NSMutableSet alloc] initWithCapacity:_visiblePages.count] autorelease];
    for (ICZoomingScrollView *page in _visiblePages) {
        if (page.captionView) [captionViews addObject:page.captionView];
    }
	
	// Animate
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
    }
    CGFloat alpha = hidden ? 0 : 1;
	[self.navigationController.navigationBar setAlpha:alpha];
    for (UIView *v in captionViews) v.alpha = alpha;
	if (animated) [UIView commitAnimations];
	
	// Control hiding timer
	// Will cancel existing timer but only begin hiding if
	// they are visible
	if (!permanent) [self hideControlsAfterDelay];
	
}

- (void)cancelControlHiding {
	// If a timer exists then cancel and release
	if (_controlVisibilityTimer) {
		[_controlVisibilityTimer invalidate];
		[_controlVisibilityTimer release];
		_controlVisibilityTimer = nil;
	}
}


// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
    
}

//控件是否隐藏
- (BOOL)areControlsHidden
{
    return [UIApplication sharedApplication].isStatusBarHidden;
}

//隐藏控件
- (void)hideControls
{
    [self setControlsHidden:YES animated:YES permanent:NO];
}

//单击事件
- (void)toggleControls
{
    [self showAndHideWidget];
}

- (void)showAndHideWidget
{
   
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //如果是下方表格的滑动，则取消处理
        return;
    }
    
    // Checks
	if (!_viewIsActive || _performingLayout || _rotating) return;
	
    
	// Tile pages
    [self tilePages];
    
	// Calculate current pagetilePagesHorizontal
	CGRect visibleBounds = _pagingScrollView.bounds;
	int index = (int)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
	NSUInteger previousCurrentPage = _currentPageIndex;
	_currentPageIndex = index;
	if (_currentPageIndex != previousCurrentPage) {
        [self didStartViewingPageAtIndex:index];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	// Hide controls when dragging begins
    //	[self setControlsHidden:YES animated:YES permanent:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// Update nav when page changes
    //	[self updateNavigation];
    
}



@end
