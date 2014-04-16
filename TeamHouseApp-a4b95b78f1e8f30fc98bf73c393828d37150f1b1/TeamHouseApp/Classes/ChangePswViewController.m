//
//  ChangePswViewController.m
//  TeamHouseApp
//
//  Created by 刘法亮 on 14-1-3.
//  Copyright (c) 2014年 liu faliang. All rights reserved.
//

#import "ChangePswViewController.h"
#import "JSONKit.h"
#import "Contents.h"
#import "ASIFormDataRequest.h"
@interface ChangePswViewController ()
{
    RequestHelp *dataRequest;
}
@end

@implementation ChangePswViewController

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
     
    
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:@"19293" forKey: @"id"];
    [contentDic setObject:@"yssd" forKey: @"用户名"];
    [contentDic setObject:@"yssd" forKey: @"用户密码"];
    
    
    NSMutableDictionary *sendDic2 = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic2 setObject:@"19293" forKey: @"id"];
    [sendDic2 setObject:@"yssd" forKey: @"原始密码"];
    [sendDic2 setObject:@"yssd" forKey: @"新密码"];
    
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic setObject:contentDic forKey:@"userkey"];
    [sendDic setObject:sendDic2 forKey:@"data"];
    NSString *sendjsonString = [sendDic JSONString];
    
    
    [dataRequest setPostData:sendjsonString];
    [dataRequest connectionWithAddress:@"http://115.28.49.147:8080/fang/doJsonUpdateUser.action"];
    
    
    
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
