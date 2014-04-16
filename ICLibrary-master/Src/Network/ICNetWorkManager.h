//
//  ICNetWorkManager.h
//  iChanceSample
//
//  Created by Fox on 13-2-6.
//
//

/**
 封转网络请求：
 1、http get 同步异步
 2、http post 同步异步
 3、websyse 同步异步
 */


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ICShowView.h"

//http网络请求时回调的块
typedef void (^http_request_block)(ASIHTTPRequest *request);



@interface ICNetWorkManager : NSObject


@property (nonatomic, retain) ASINetworkQueue *requestQueue;



#pragma mark - 单例处理
+ (ICNetWorkManager *)shareInstance;



#pragma mark - Http Get 请求
//异步请求
- (void)startHttpAsychronousRequest:(NSString *)requestUrl
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest;

//同步请求
- (void)startHttpSynchronousRequest:(NSString *)requestUrl
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest;

//同步请求+加载中效果    （只有同步才需要添加加载中效果）
- (void)startHttpSynchronousRequest:(NSString *)requestUrl
                         targetView:(UIView *)target
                        loadingText:(NSString *)loadingText
                   didFinishRequest:(http_request_block)didFinishRequest
                   didFailedRequest:(http_request_block)didFailedRequest;


#pragma mark - HttpPost 请求
//异步请求
- (void)startHttpPostAsychronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest;

//同步请求
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest;

//同步请求+加载中效果
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest;
//同步请求+上传数据
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             uploadData:(NSDictionary *)uploadData
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest;

//同步请求+加载中效果+上传数据
- (void)startHttpPostSynchronousRequest:(NSString *)baseUrl
                               postData:(NSDictionary *)postData
                             uploadData:(NSDictionary *)uploadData
                             targetView:(UIView *)target
                            loadingText:(NSString *)loadingText
                       didFinishRequest:(http_request_block)didFinishRequest
                       didFailedRequest:(http_request_block)didFailedRequest;


/**
 Http Post 和 Web Service 调用的区别：
 1、Http Post 是以键值对的形式传入参数，而Web Service以一定的封装格式，不是键值对的形式传输。
 2、从表现形式上Http post添加参数是设置[request setPostValue:[postData objectForKey:key] forKey:key];
    而Web Service是将数据全部封装成一个字符串之后，通过[request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    来添加。
 */
#pragma mark - Web Service  异步请求
- (void)startSyWebAsychronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest;

#pragma mark - Web Service  同步请求
//同步请求
- (void)startSyWebSynchronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest;

//同步请求+加载中效果
- (void)startSywebSynchronousRequest:(NSString *)baseUrl
                          postStirng:(NSString *)postString
                          targetView:(UIView *)target
                         loadingText:(NSString *)loadingText
                    didFinishRequest:(http_request_block)didFinishRequest
                    didFailedRequest:(http_request_block)didFailedRequest;



@end
