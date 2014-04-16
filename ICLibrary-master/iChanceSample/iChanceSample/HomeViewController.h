//
//  HomeViewController.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_dataSource;
}
@end
