//
//  HouseRentViewController.m
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-31.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "HouseRentViewController.h"
#import "JSONKit.h"
#import "Contents.h"
#import "ASIFormDataRequest.h"
@interface HouseRentViewController ()
{
    RequestHelp *dataRequest;
}
@end

@implementation HouseRentViewController

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
    
    NSLog(@"出租房屋");
    
    
    //个人中心接口   19293
    
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:@"19293" forKey: @"userid"];
    [contentDic setObject:@"yssd" forKey: @"password"];
    
    
    
//    NSMutableDictionary *sendDic2 = [[NSMutableDictionary alloc]initWithCapacity:10];
//    [sendDic2 setObject:@"1" forKey: @"pageno"];
//    [sendDic2 setObject:@"" forKey: @"pos_x"];
//    [sendDic2 setObject:@"" forKey: @"pos_y"];
//    [sendDic2 setObject:@"" forKey: @"house_type"];
//    [sendDic2 setObject:@"" forKey: @"pattern_type"];
//    [sendDic2 setObject:@"" forKey: @"area_local"];
//    [sendDic2 setObject:@"" forKey: @"pay_type"];
//    [sendDic2 setObject:@"" forKey: @"house_mny"];
    
    
    NSMutableDictionary *sendDic2 = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic2 setObject:@"1" forKey: @"pageno"];
    [sendDic2 setObject:@"116.41004950566" forKey: @"pos_x"];
    [sendDic2 setObject:@"39.916979519873" forKey: @"pos_y"];
    [sendDic2 setObject:@"公寓" forKey: @"house_type"];
    [sendDic2 setObject:@"二室" forKey: @"pattern_type"];
    [sendDic2 setObject:@"朝阳区" forKey: @"area_local"];
    [sendDic2 setObject:@"季付" forKey: @"pay_type"];
    [sendDic2 setObject:@"500,1000" forKey: @"house_mny"];
    
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [sendDic setObject:contentDic forKey:@"userkey"];
    [sendDic setObject:sendDic2 forKey:@"data"];
    NSString *sendjsonString = [sendDic JSONString];
    
    
    [dataRequest setPostData:sendjsonString];
    [dataRequest connectionWithAddress:@"http://115.28.49.147:8080/fang/doJsonSearchRentHouse.action"];
    
    
    
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
