//
//  ICNetWorkManager.m
//  iChanceSample
//
//  Created by Fox on 13-2-6.
//
//




#import "ICNetWorkManager.h"

#define TIME_OUT_SECOND 30


@implementation ICNetWorkManager

static ICNetWorkManager *g_instance = nil;

@synthesize requestQueue;

#pragma mark - Memory manager
-(void)dealloc
{
    [super dealloc];
}

#pragma mark - Init
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



#pragma mark - 单例处理
+(ICNetWorkManager *)shareInstance
{
    @synchronized(self){
        if (g_instance == nil) {
            g_instance = [[self alloc] init];
        }
    }
    
    return g_instance;
}

#pragma mark - 判断请求是否成功
- (BOOL) isRequestSucceed:(ASIHTTPRequest *)request
{
    //这里只是判断Http通信是都正确，具体业务逻辑是否正确需要根据需求而定
    if(request.responseStatusCode/100==2)
        return YES;
    else
        return NO;
}

#pragma mark - Http Get 请求
//异步请求
- (void)startHttpAsychronousRequest:(NSString *)requestUrl
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:didFinishRequest forKey:@"didfinishedmethod"];
    [info setObject:didFailedRequest forKey:@"didfailededmethod"];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setDelegate:self];
    //指定回调方法
    [request setDidFinishSelector:@selector(httpAsynRequestDidFinished:)];
    [request setDidFailSelector:@selector(httpAsynRequestDidFailed:)];
    request.userInfo = info;
    request.timeOutSeconds = TIME_OUT_SECOND;
    [self.requestQueue addOperation:request];
    [self.requestQueue go];
    
}

//同步请求
- (void)startHttpSynchronousRequest:(NSString *)requestUrl
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpSynchronousRequest:requestUrl isShowLoading:NO targetView:nil loadingText:@"" didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

//同步请求+加载中效果    （只有同步才需要添加加载中效果）
- (void)startHttpSynchronousRequest:(NSString *)requestUrl
                         targetView:(UIView *)target
                        loadingText:(NSString *)loadingText
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpSynchronousRequest:requestUrl isShowLoading:YES targetView:target  loadingText:loadingText didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

//同步请求，最终通过这里执行，前面都是参数处理
- (void)startHttpSynchronousRequest:(NSString *)requestUrl
                      isShowLoading:(BOOL)isShowLoading
                         targetView:(UIView *)target
                        loadingText:(NSString *)loadingText
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest
{
    //先判断是否需要添加加载中效果
    if (isShowLoading == NO) {
        //不用添加加载中效果
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        request.timeOutSeconds=TIME_OUT_SECOND;
        [request startSynchronous];
        if([self isRequestSucceed:request])
            didFinishRequest(request);
        else
            didFailedRequest(request);
    }else{
        //需要添加加载中效果
        __block ASIHTTPRequest *request;
        [ICShowView showMBAlertView:target message:loadingText whileExecutingBlock:^{
            request=[[ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]] retain];
            request.timeOutSeconds=TIME_OUT_SECOND;
            [request startSynchronous];
        } completionBlock:^{
            if([self isRequestSucceed:request])
                didFinishRequest(request);
            else
                didFailedRequest(request);
            [request release];
        }];
    }
}





#pragma mark - HttpPost 请求
//异步请求
- (void)startHttpPostAsychronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:didFinishRequest forKey:@"finishedMethod"];
    [dic setObject:didFailedRequest forKey:@"failedMethod"];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    for(NSString *key in postData.keyEnumerator){
        [request setPostValue:[postData objectForKey:key] forKey:key];
    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(httpAsynRequestDidFinished:)];
    [request setDidFailSelector:@selector(httpAsynRequestDidFailed:)];
    request.timeOutSeconds=TIME_OUT_SECOND;
    request.userInfo=dic;
    [self.requestQueue addOperation:request];
    [self.requestQueue go];
}

//同步请求
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpPostSynchronousRequest:baseUrl postData:postData isShowLoading:NO targetView:nil loadingText:@"" didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

//同步请求+加载中效果
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpPostSynchronousRequest:baseUrl postData:postData
                            isShowLoading:YES targetView:target
                              loadingText:loadingText
                         didFinishRequest:didFinishRequest
                         didFailedRequest:didFailedRequest];
}

- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                      isShowLoading:(BOOL)isShowLoading
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    if (NO == isShowLoading) {
        //不用显示加载中效果
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]];
        for(NSString *key in postData.keyEnumerator){
            [request setPostValue:[postData objectForKey:key] forKey:key];
        }
        request.timeOutSeconds=TIME_OUT_SECOND;
        [request startSynchronous];
        if([self isRequestSucceed:request])
            didFinishRequest(request);
        else
            didFailedRequest(request);
    }else{
        //需要显示加载中效果
        __block ASIFormDataRequest *request;
        [ICShowView showMBAlertView:target message:loadingText whileExecutingBlock:^{
            request=[[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]] retain];
            for(NSString *key in postData.keyEnumerator){
                [request setPostValue:[postData objectForKey:key] forKey:key];
            }
            request.timeOutSeconds=TIME_OUT_SECOND;
            [request startSynchronous];
        } completionBlock:^{
            if([self isRequestSucceed:request])
                didFinishRequest(request);
            else
                didFailedRequest(request);
            [request release];
        }];
    }
}




//同步请求+上传数据
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             uploadData:(NSDictionary *)uploadData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpPostSynchronousRequest:baseUrl postData:postData uploadData:uploadData isShowLoading:NO targetView:nil loadingText:@"" didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

//同步请求+加载中效果+上传数据
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             uploadData:(NSDictionary *)uploadData
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    [self startHttpPostSynchronousRequest:baseUrl postData:postData uploadData:uploadData isShowLoading:YES targetView:target loadingText:loadingText didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             uploadData:(NSDictionary *)uploadData
                          isShowLoading:(BOOL)isShowLoading
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest
{
    if (isShowLoading == NO) {
      //不需要加载种效果
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]];
        for(NSString *key in postData.keyEnumerator)
        {
            [request setPostValue:[postData objectForKey:key] forKey:key];
        }
        for(NSString *key in uploadData.keyEnumerator){
            [request addData:[uploadData objectForKey:key] forKey:key];
        }
        
        request.timeOutSeconds=TIME_OUT_SECOND;
        [request startSynchronous];
        if([self isRequestSucceed:request])
            didFinishRequest(request);
        else
            didFailedRequest(request);
    }else{
      //需要加载中效果
        __block ASIFormDataRequest *request;
        [ICShowView showMBAlertView:target message:loadingText whileExecutingBlock:^{
            request=[[ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]] retain];
            for(NSString *key in postData.keyEnumerator)
            {
                [request setPostValue:[postData objectForKey:key] forKey:key];
            }
            for(NSString *key in uploadData.keyEnumerator)
            {
                [request addData:[uploadData objectForKey:key] forKey:key];
            }
            request.timeOutSeconds=TIME_OUT_SECOND;
            [request startSynchronous];
        } completionBlock:^{
            if([self isRequestSucceed:request])
                didFinishRequest(request);
            else
                didFailedRequest(request);
            [request release];
        }];
    }
}


#pragma mark - Http 异步请求回调
- (void)httpAsynRequestDidFinished:(ASIHTTPRequest *)request
{
    //请求完成,执行block
    http_request_block block = [request.userInfo objectForKey:@"didfinishedmethod"];
    block(request);
}

- (void)httpAsynRequestDidFailed:(ASIHTTPRequest *)request
{
    //请求失败
    http_request_block block = [request.userInfo objectForKey:@"didfailededmethod"];
    block(request);
}

#pragma mark - Web Service  异步请求
- (void)startSyWebAsychronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:didFinishRequest forKey:@"didfinishedmethod"];
    [info setObject:didFailedRequest forKey:@"didfailededmethod"];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];//一定要设置
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];//发送时使用UTF8编码一次
    [request setRequestMethod:@"POST"];
    request.userInfo = info;
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(syWebAsynRequestDidFinished:)];
    [request setDidFailSelector:@selector(syWebAsynRequestDidFailed:)];
    [request setTimeOutSeconds:TIME_OUT_SECOND];
    
    [self.requestQueue addOperation:request];
    [self.requestQueue go];
}

#pragma mark - Web Service  同步请求
//同步请求
- (void)startSyWebSynchronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest
{
    [self startSywebSynchronousRequest:baseUrl postStirng:postString isShowLoading:NO targetView:nil loadingText:@"" didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

//同步请求+加载中效果
- (void)startSywebSynchronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                          targetView:(UIView *)target
                         loadingText:(NSString *)loadingText
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest
{
    [self startSywebSynchronousRequest:baseUrl postStirng:postString isShowLoading:YES targetView:target  loadingText:loadingText didFinishRequest:didFinishRequest didFailedRequest:didFailedRequest];
}

- (void)startSywebSynchronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                       isShowLoading:(BOOL)isShowLoading
                          targetView:(UIView *)target
                         loadingText:(NSString *)loadingText
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest
{
    if (isShowLoading == NO) {
        //不显示加载中效果
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseUrl]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];//一定要设置
        [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];//发送时使用UTF8编码一次
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:TIME_OUT_SECOND];
        
        [request startSynchronous];
        
        if ([self isRequestSucceed:request]) {
            didFinishRequest(request);
        }else{
            didFailedRequest(request);
        }
    
        
    }else{
        //显示加载中效果
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseUrl]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];//一定要设置
        [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];//发送时使用UTF8编码一次
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:TIME_OUT_SECOND];
        
        [ICShowView showMBAlertView:target message:loadingText  whileExecutingBlock:^{
            [request startSynchronous];
        } completionBlock:^{
            if ([self isRequestSucceed:request]) {
                didFinishRequest(request);
            }else{
                didFailedRequest(request);
            }
        }];
    }
}

#pragma mark - Web Service 异步请求回调
- (void)syWebAsynRequestDidFinished:(ASIHTTPRequest *)request
{
    //请求完成
    http_request_block block = [request.userInfo objectForKey:@"didfinishedmethod"];
    block(request);
}

- (void)syWebAsynRequestDidFailed:(ASIHTTPRequest *)request
{
    //请求失败
    http_request_block block = [request.userInfo objectForKey:@"didfailededmethod"];
    block(request);
}

@end
