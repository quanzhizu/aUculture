//
//  FirstViewController.h
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface FirstViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView * mytableView;
@property (nonatomic, strong) NSMutableArray * numberArray;
@end
