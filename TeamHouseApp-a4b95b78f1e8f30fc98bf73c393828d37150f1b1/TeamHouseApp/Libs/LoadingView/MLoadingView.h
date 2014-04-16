//
//  MLoadingView.h
//  LoadingTest
//
//  Created by  on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLoadingView : UIView
{
    UIView *acView;

    UILabel *tipLabel;
}

@property (nonatomic, retain) UIView *acView;
@property (nonatomic, retain) UILabel *tipLabel;


-(void) showLoadingView:(NSString *)tip;

-(void) hiddenLoadingView;

-(void) loadSuccessTip:(NSString *)tip;

-(void) setAcViewFrame:(CGRect)rect;

@end
