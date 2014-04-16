//
//  ICPullTableViewController.h
//  iChanceSample
//
//  Created by Fox on 13-3-2.
//
//

#import "ICBaseViewController.h"
#import "PullingRefreshTableView.h"

@interface ICPullTableViewController : ICBaseViewController <UITableViewDataSource,UITableViewDelegate,
PullingRefreshTableViewDelegate>

@end
