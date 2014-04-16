//
//  LoadViewController.h
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-23.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "CustomViewController.h"
#import "RequestHelp.h"
#import "ASIHTTPRequestDelegate.h"
@interface LoadViewController : CustomViewController<DataRequestDelegate,ASIHTTPRequestDelegate>

@end
