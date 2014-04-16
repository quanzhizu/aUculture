//
//  ICNetworkViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICNetworkViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CommonHelper.h"
#import "XMLReader.h"


#import <objc/runtime.h>
#import <objc/message.h>

@interface ICNetworkViewController ()

@end

@implementation ICNetworkViewController

#pragma mark - Memory manager
-(void)dealloc
{
    [super dealloc];
}

#pragma mark - UIViewController life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ICNetworkViewController";

    self.title = NSLocalizedString(@"HelloKey", @"12121");   

    
    
    [[ICNetWorkManager shareInstance] startHttpSynchronousRequest:@"http://kbpad.hbjt.com.cn/apiNew?method=getNewsByPage&updatedDate=1359349486&channelId=4&pageSize=24&pageIndex=1&deviceType=1" targetView:self.view loadingText:@"加载中啊" didFinishRequest:^(ASIHTTPRequest *request) {
        NSLog(@"%@",request.responseString);
    } didFailedRequest:^(ASIHTTPRequest *request) {
         NSLog(@"%@",request.responseString);
    }];
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
