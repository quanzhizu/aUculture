//
//  MLoadFailView.h
//  Portal
//
//  Created by  on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadDataDelegate ;

@interface MLoadFailView : UIView
{
    id<ReloadDataDelegate> delegate;
}

@property (nonatomic, strong) id<ReloadDataDelegate> delegate;

@end


//加载失败
@protocol ReloadDataDelegate <NSObject>

@optional

//重新加载数据
-(void) reloadData:(id)sender;

@end