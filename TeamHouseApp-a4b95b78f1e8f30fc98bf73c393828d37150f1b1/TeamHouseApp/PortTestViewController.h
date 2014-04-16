//
//  PortTestViewController.h
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-31.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "CustomViewController.h"

@interface PortTestViewController : CustomViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
    
}
@end
