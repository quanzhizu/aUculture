//
//  PosionInfoViewController.m
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-31.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "PosionInfoViewController.h"
#import "JSONKit.h"
#import "Contents.h"
#import "ASIFormDataRequest.h"
@interface PosionInfoViewController ()
{
    RequestHelp *dataRequest;
}
@end

@implementation PosionInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataRequest = [[RequestHelp alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"LoadView");
    
    dataRequest.delegate = self;
    
    NSLog(@"位置信息");
    
    //个人中心接口   19293
    
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:@"19293" forKey: @"userid"];
    [contentDic setObject:@"yssd" forKey: @"password"];
    
    
    
    
    NSMutableDictionary *sendDic2 = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic2 setObject:@"19293" forKey: @"id"];
    [sendDic2 setObject:@"116.41004950566" forKey: @"pos_x"];
    [sendDic2 setObject:@"39.916979519873" forKey: @"pos_y"];
    [sendDic2 setObject:@"北京市海淀区清华科技园" forKey: @"place"];
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic setObject:contentDic forKey:@"userkey"];
    [sendDic setObject:sendDic2 forKey:@"data"];
    NSString *sendjsonString = [sendDic JSONString];
    
    
    [dataRequest setPostData:sendjsonString];
    [dataRequest connectionWithAddress:SERVER_UserInfo];
    
    
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request responseString]);
}


-(void)connectionFinished:(RequestHelp *)request backString:(NSString *)backXmlString
{
    NSLog(@"backXmlString %@",backXmlString);
    NSDictionary *temdic = [backXmlString objectFromJSONString];
    NSLog(@"temdic %@",temdic);
    
}
-(void)connectionFailed
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
