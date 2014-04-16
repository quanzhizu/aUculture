//
//  ICSpanlishViewController.h
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICBaseViewController.h"

@protocol ICSpanlishDelegate;

@interface ICSpanlishViewController : ICBaseViewController
{
    id<ICSpanlishDelegate> delegate;
}

@property(nonatomic, retain) NSMutableArray *frameArr;
@property(nonatomic, retain) NSMutableArray *radomArr;
@property(nonatomic, assign) id<ICSpanlishDelegate> delegate;

@end


@protocol ICSpanlishDelegate <NSObject>

/**
 * @brief   启动画面结束
 */
-(void)EndSplish:(ICSpanlishViewController *)spanlishViewController;
@end