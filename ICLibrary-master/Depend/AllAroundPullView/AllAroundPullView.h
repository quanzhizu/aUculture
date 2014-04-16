//  
//  AllAroundPullView.h
//  
//  Created by r_plus on 9/2/12
//  Copyright (c) 2012 r_plus All rights reserved.
//
//  https://github.com/r-plus/AllAroundPullView
//
//  based on twobitlabs modified version of PullToRefreshView by Grant Paul (chpwn)
//


/**
 @eg:
 //强转为__block类型，否则在块内执行时会将self的引用计数+1。
 __block typeof(self) blockself = self;
 
 bottomPullView = [[AllAroundPullView alloc]
 initWithScrollView:self.mainViewTable 
 position:AllAroundPullViewPositionBottom 
 action:^(AllAroundPullView *view){
 [blockself pullToupdate];
 }];
 
 
 [self.mainViewTable addSubview:bottomPullView];
 
 //将mainviewtable的引用计数-1，因为bottomPullview初始化中，将mainViewTable引用计数+1.
 //如果不减，则mainviewTable和bottomPullView都将不会释放
 [self.mainViewTable release];
 */




#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
  AllAroundPullViewStateNormal = 0,
  AllAroundPullViewStateReady,
  AllAroundPullViewStateLoading,
  AllAroundPullViewStateNone
} AllAroundPullViewState;

typedef enum {
  AllAroundPullViewPositionTop = 1 << 0,
  AllAroundPullViewPositionBottom = 1 << 1,
  AllAroundPullViewPositionLeft = 1 << 2,
  AllAroundPullViewPositionRight = 1 << 3
} AllAroundPullViewPosition;

@interface AllAroundPullView : UIView {
  AllAroundPullViewState _state;
  AllAroundPullViewPosition _position;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalInset;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, retain) CALayer *arrowImage;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, readonly) BOOL isSideView;
@property (assign, readonly) AllAroundPullViewPosition position;
@property (nonatomic, copy) void (^allAroundPullViewActionHandler)(AllAroundPullView *view);

- (void)finishedLoading;
- (void)hideAllAroundPullViewIfNeed:(BOOL)disable;
- (id)initWithScrollView:(UIScrollView *)scroll 
                position:(AllAroundPullViewPosition)position 
                  action:(void (^)(AllAroundPullView *view))actionHandler;

@end
