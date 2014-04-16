//
//  RequestHelp.h
//  RainBrowser
//
//  Created by  on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@protocol DataRequestDelegate;

@interface RequestHelp : NSObject<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest *theRequest;
    NSString *postData;
    BOOL running;                 //是否正在请求
    BOOL reqSuc;                  //请求成功:YES 失败:NO
    id<DataRequestDelegate> delegate;
}

@property (nonatomic) BOOL running;
@property (nonatomic) BOOL reqSuc; 
@property(nonatomic,assign) id<DataRequestDelegate> delegate;
@property(nonatomic,retain) NSString *postData;


-(void)connectionWithAddress:(NSString *)urlString;

-(void)cancelRequest;
@end


//网络连接代理
@protocol DataRequestDelegate <NSObject>

@optional

//网络连接开始
-(void)connectionStart;

//请求成功，返回对应的表单
-(void)connectionFinished:(RequestHelp *)request backString:(NSString *)backXmlString;

//请求失败
-(void)connectionFailed;

//请求失败,带参数
-(void)connectionFailed:(RequestHelp *)request;



@end
