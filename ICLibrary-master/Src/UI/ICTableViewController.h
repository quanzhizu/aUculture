//
//  ICTableViewController.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICBaseViewController.h"
#import "PullingRefreshTableView.h"

@interface ICTableViewController : ICBaseViewController <UITableViewDelegate,UITableViewDataSource,
    PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    PullingRefreshTableView *_pullingRefreshTableView;
    
    NSMutableArray *_dataSource;
}
@end
