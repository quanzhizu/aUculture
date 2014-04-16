//
//  RequestHelp.m
//  RainBrowser
//
//  Created by  on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestHelp.h"
 


@implementation RequestHelp

@synthesize delegate,postData,running,reqSuc;

-(id)init
{
    //theRequest = [[ASIHTTPRequest alloc] init];
     if(self = [super init])
     {
         reqSuc = YES;
     }
    return self;
}
#pragma mark 外部方法

-(void)connectionWithAddress:(NSString *)urlString
{
	if (running) {
        [theRequest clearDelegatesAndCancel];
        running = NO;
	}
	running = YES;
    
    if([delegate respondsToSelector:@selector(connectionStart)])
    {
        [delegate connectionStart];
    }
    
	theRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
	[theRequest setRequestMethod:@"POST"];
    theRequest.shouldAttemptPersistentConnection=NO;//设置关闭长连接
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml"];
	[theRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [postData length]]];
	[theRequest setPostValue:postData forKey:@"params"];
    
    UIImage *image = [UIImage imageNamed:@"test.png"];
    NSData *datae = UIImageJPEGRepresentation(image,1.0);
    [theRequest setData:datae forKey:@"fileimg"];
    [theRequest setTimeOutSeconds:15.0];
	[theRequest setDelegate:self];
	[theRequest startAsynchronous];
}


#pragma mark ASIHTTPRequestDelegate代理
//请求成功
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(delegate ==nil)
        return;
    
    reqSuc = YES;
    running = NO;
    NSString *responseString = [request responseString];
    
    if([delegate respondsToSelector:@selector(connectionFinished:backString:)])
    {
        [delegate connectionFinished:self backString:responseString];
    }
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if(delegate ==nil)
        return;
    
    reqSuc = NO;
    running = NO;

    if([delegate respondsToSelector:@selector(connectionFailed)])
    {
        [delegate connectionFailed];
    }
    
    if([delegate respondsToSelector:@selector(connectionFailed:)])
    {
        [delegate connectionFailed:self];
    }
}


-(void) cancelRequest
{
    if(running)
    {
        [theRequest cancel];
    }
    
    
}


- (void)dealloc
{
    if (running)        
    { 
        [theRequest clearDelegatesAndCancel];
   
    } 
    [postData release];

    [super dealloc];
}



@end
