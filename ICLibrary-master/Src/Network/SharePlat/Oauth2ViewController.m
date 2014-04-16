//
//  Oauth2ViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import "Oauth2ViewController.h"
#import "UIColor+ICCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface Oauth2ViewController ()

@end

@implementation Oauth2ViewController
{
    UIActivityIndicatorView *indicator;
    CGRect webViewFrame;//此视图中webview的位置，相对于自己这个view的位置。
    CGRect selfViewFrame;//自己视图的view位置
    BOOL isRetained;//是否已经retain过，已经retain过，则show的时候不再retain
    BOOL isAddToParent;//自己的视图是不是已经被加到
}

@synthesize webView;
@synthesize oauthType;
@synthesize cancelButton;
@synthesize type;
@synthesize target;
@synthesize delegate;

#pragma mark - Memory manager
- (void) dealloc
{
    [indicator release];
    
    self.type=nil;
    self.webView =nil;
    self.cancelButton=nil;
    
    [super dealloc];
}


- (id) initWithFrame:(CGRect)frame _oauthType:(OauthType)_oauthType//初始化方法
{
    self=[super init];
    if(self)
    {
        webViewFrame = CGRectMake(10,10,frame.size.width-20,frame.size.height-20);
        selfViewFrame = frame;
        self.oauthType = _oauthType;
        self.view.backgroundColor=[UIColor colorForHex:@"1C374C"];
        self.view.layer.cornerRadius=8;
        
        //根据选择的类型，对参数赋值
        switch (self.oauthType) {
            case OauthTypeSinaWeibo:
                self.type=[Oauth2Type type:OauthTypeSinaWeibo];
                break;
            case OauthTypeTencentWeibo:
                self.type=[Oauth2Type type:OauthTypeTencentWeibo];
                break;
            case OauthTypeQQ:
                self.type=[Oauth2Type type:OauthTypeQQ];
                break;
            case OauthTypeWeixin:
                self.type=[Oauth2Type type:OauthTypeWeixin];
                break;
            case OauthTypeRenren:
                self.type=[Oauth2Type type:OauthTypeRenren];
                break;
            default:
                break;
        }
    }
    return self;
}
- (id) initWithType:(OauthType)_oauthType//默认全屏
{
    CGRect frame=[[UIScreen mainScreen] applicationFrame];
    return [self initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)_oauthType:_oauthType];
}
- (void) show
{
    if(isRetained==NO)
    {
        [self retain];
        isRetained=YES;
    }
    [self.target addSubview:self.view];
    //放置webview
    if(self.webView==nil)
    {
        self.webView=[[[UIWebView alloc] initWithFrame:webViewFrame] autorelease];
        self.webView.delegate=self;
        self.webView.backgroundColor=[UIColor yellowColor];
        [self.view addSubview:self.webView];
    }
    
    //取消按钮
    if(self.cancelButton==nil)
    {
        self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame=CGRectMake(webViewFrame.origin.x+webViewFrame.size.width-20,webViewFrame.origin.y-10, 30, 30);
        //        self.cancelButton.backgroundColor=[UIColor redColor];
        [self.cancelButton setImage:[UIImage imageNamed:@"oauth_view_close_buttom.png"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.cancelButton];
    }
    
    self.view.hidden=NO;
    
    NSLog(@"授权地址：%@",self.type.authorUrlStr);
    NSURL *url=[NSURL URLWithString:self.type.authorUrlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// 设置此视图位置距离
    self.view.frame=selfViewFrame;
    self.view.backgroundColor=[UIColor brownColor];
    self.view.hidden=YES;
}

#pragma mark - webview 回调方法
- (BOOL)webView:(UIWebView *)sender shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *redirectURLStr=request.URL.absoluteString;
    NSLog(@"start url:%@",redirectURLStr);
    if([redirectURLStr hasPrefix:self.type.appRedirect])
    {
        NSDictionary *dic=[self parametersInURLStr:redirectURLStr];
        NSLog(@"回调成功，授权码为：%@",dic);
        [self saveAuthoredInfo:self.oauthType authoredInfo:dic];
        if([self.delegate respondsToSelector:@selector(oauthRequestFinished:returnCode:returnMessage:)])
        {
            [self.delegate oauthRequestFinished:self returnCode:OauthRequestAccessToken returnMessage:[dic objectForKey:@"access_token"]];
        }
        [self close];
    }
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(indicator==nil)
    {
        indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame=CGRectMake(webViewFrame.origin.x+webViewFrame.size.width/2-12.5f,webViewFrame.origin.y+webViewFrame.size.height/2-12.5f,25, 25);
        [indicator startAnimating];
        [self.view addSubview:indicator];
    }
    indicator.hidden=NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [indicator removeFromSuperview];
    indicator.hidden=YES;
}

#pragma mark - 内部方法
//url形式如：http://www.cimu.com.cn/#access_token=2.00x6FVvCXR329C677a77cca6h_pqFB&remind_in=553152&expires_in=553152&uid=2681925813
- (NSDictionary *) parametersInURLStr:(NSString *)urlStr
{
    NSArray *sep1=[urlStr componentsSeparatedByString:@"#"];
    NSString *parameterStr=[sep1 objectAtIndex:1];
    
    NSArray *sep2=[parameterStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *parameter=[[[NSMutableDictionary alloc] init] autorelease];
    for(NSString *pair in sep2)
    {
        NSArray *keyAndValue=[pair componentsSeparatedByString:@"="];
        [parameter setObject:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
    }
    return parameter;
}
//根据类型将数据存入缓存
- (void) saveAuthoredInfo:(OauthType)_oauthType authoredInfo:(NSDictionary *) authoredInfo
{
    switch (_oauthType)
    {
        case OauthTypeSinaWeibo:
        {
            [self.userDefault setObject:[authoredInfo objectForKey:@"access_token"] forKey:self.type.accessTokenName];
            [self.userDefault setObject:[authoredInfo objectForKey:@"uid"] forKey:self.type.accessUidName];
            
            NSDate *expireDate;
            NSDate *date=[NSDate date];
            expireDate=[NSDate dateWithTimeInterval:[[authoredInfo objectForKey:@"expires_in"] doubleValue] sinceDate:date];
            NSLog(@"expreMills:%f",[[authoredInfo objectForKey:@"expires_in"] doubleValue]);
            NSLog(@"现在时间：%@\n accessToken截止时间：%@",date,expireDate);
            [self.userDefault setValue:expireDate forKey:self.type.accessTokenExpiresName];
        }
            break;
        case OauthTypeTencentWeibo:
        {
            [self.userDefault setObject:[authoredInfo objectForKey:@"access_token"] forKey:self.type.accessTokenName];
            [self.userDefault setObject:[authoredInfo objectForKey:@"openid"] forKey:self.type.accessUidName];
            
            NSDate *expireDate;
            NSDate *date=[NSDate date];
            expireDate=[NSDate dateWithTimeInterval:[[authoredInfo objectForKey:@"expires_in"] doubleValue] sinceDate:date];
            NSLog(@"expreMills:%f",[[authoredInfo objectForKey:@"expires_in"] doubleValue]);
            NSLog(@"现在时间：%@\n accessToken截止时间：%@",date,expireDate);
            [self.userDefault setValue:expireDate forKey:self.type.accessTokenExpiresName];
        }
            break;
        case OauthTypeQQ:
        {
            [self.userDefault setObject:[authoredInfo objectForKey:@"access_token"] forKey:self.type.accessTokenName];
            //通过access_token获得uid
            
            
            
            
            [self getAsynchronousRequest:self requestUrl:[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@",[authoredInfo objectForKey:@"access_token"]] didFinishedRequest:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
            
                //返回值是callback( {"client_id":"100298246","openid":"EF2509D78367F871D9975B4AC616CACA"} };,所以要把边上的去掉，否则不能转化为字典。
                NSString *dicStr=[[response stringByReplacingOccurrencesOfString:@"callback( " withString:@""] stringByReplacingOccurrencesOfString:@" );" withString:@""];
                
                NSDictionary *qqDic=[dicStr objectFromJSONString];
                
                [self.userDefault setObject:[qqDic objectForKey:@"openid"] forKey:self.type.accessUidName];
            } didFailedRequest:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            
            }];
            
            
            [self startSynchronousRequest:[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@",[authoredInfo objectForKey:@"access_token"]] didFinishRequest:^(ASIHTTPRequest *request) {
                //返回值是callback( {"client_id":"100298246","openid":"EF2509D78367F871D9975B4AC616CACA"} };,所以要把边上的去掉，否则不能转化为字典。
                NSString *dicStr=[[request.responseString stringByReplacingOccurrencesOfString:@"callback( " withString:@""] stringByReplacingOccurrencesOfString:@" );" withString:@""];
                
                NSDictionary *qqDic=[dicStr objectFromJSONString];
                
                [self.userDefault setObject:[qqDic objectForKey:@"openid"] forKey:self.type.accessUidName];
                
            } didFailedRequest:^(ASIHTTPRequest *request) {
                
            }];
            
            NSDate *expireDate;
            NSDate *date=[NSDate date];
            expireDate=[NSDate dateWithTimeInterval:[[authoredInfo objectForKey:@"expires_in"] doubleValue] sinceDate:date];
            NSLog(@"expreMills:%f",[[authoredInfo objectForKey:@"expires_in"] doubleValue]);
            NSLog(@"现在时间：%@\n accessToken截止时间：%@",date,expireDate);
            [self.userDefault setValue:expireDate forKey:self.type.accessTokenExpiresName];
        }
            break;
        case OauthTypeRenren:
        {
            //人人返回的accessToken中有|字符，被浏览器转义了，需要解码回去
            NSString *accessToken=[[authoredInfo objectForKey:@"access_token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self.userDefault setObject:accessToken forKey:self.type.accessTokenName];
            //获得用户uid
            NSMutableDictionary *muDic=[NSMutableDictionary dictionary];
            
            [muDic setObject:@"users.getLoggedInUser" forKey:@"method"];
            [muDic setObject:accessToken forKey:@"access_token"];
            [muDic setObject:@"1.0" forKey:@"v"];
            [muDic setObject:@"JSON" forKey:@"format"];
            
            [muDic setObject:[self ecodeRenrenSig:muDic secret:self.type.appSecret] forKey:@"sig"];
            
            NSLog(@"%@",muDic);
            [self startSynchronousPostRequest:@"http://api.renren.com/restserver.do" postData:muDic didFinishRequest:^(ASIHTTPRequest *request)
             {
                 NSLog(@"%@",request.responseString);
                 NSDictionary *respData=[request.responseString objectFromJSONString];
                 [self.userDefault setObject:[respData objectForKey:@"uid"] forKey:self.type.accessUidName];
             } didFailedRequest:^(ASIHTTPRequest *request) {
                 
             }];
            
            NSDate *expireDate;
            NSDate *date=[NSDate date];
            expireDate=[NSDate dateWithTimeInterval:[[authoredInfo objectForKey:@"expires_in"] doubleValue] sinceDate:date];
            NSLog(@"expreMills:%f",[[authoredInfo objectForKey:@"expires_in"] doubleValue]);
            NSLog(@"现在时间：%@\n accessToken截止时间：%@",date,expireDate);
            [self.userDefault setValue:expireDate forKey:self.type.accessTokenExpiresName];
        }
            break;
        default:
            break;
    }
    
}
- (void) close
{
    [self.view removeFromSuperview];
    NSLog(@"self retainCount:%d",self.retainCount);
    isRetained=NO;
    [self release];//因为一开始就retain了
    //    self=nil;
}
+ (BOOL) isLogin:(OauthType)oauthType
{
    if([[Oauth2ViewController accessToken:oauthType] length]>0)
        return YES;
    else
        return NO;
    
}
+ (NSString *)accessToken:(OauthType)oauthType
{
    Oauth2Type *type=[Oauth2Type type:oauthType];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:type.accessTokenName];
    NSLog(@"accessToken from user defaults:%@",token);
    NSDate *now=[NSDate date];
    
    NSDate *expiresTime=[[NSUserDefaults standardUserDefaults] valueForKey:type.accessTokenExpiresName];
    NSLog(@"现在时间：%@\n截止时间：%@",now,expiresTime);
    
    if(token.length==0||[now timeIntervalSince1970]>[expiresTime timeIntervalSince1970])
        return nil;
    else
        return token;
}

+ (NSString *)uid:(OauthType)oauthType
{
    Oauth2Type *type=[Oauth2Type type:oauthType];
    return [[NSUserDefaults standardUserDefaults] objectForKey:type.accessUidName];
}

+ (void) removeAllTokenInfo
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    for (OauthType type=OauthTypeTaoBao; type < OauthTypePengyouQuan;type=type+1)
    {
        Oauth2Type *oauth2Type=[[Oauth2Type alloc] initWithOauthType:type];
        [userDefault removeObjectForKey:oauth2Type.accessTokenName];
        [userDefault removeObjectForKey:oauth2Type.accessTokenExpiresName];
        [userDefault removeObjectForKey:oauth2Type.accessUidName];
        [oauth2Type release];
    }
}
+ (void) removeTokenInfoByType:(OauthType) oauthType
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    Oauth2Type *oauth2Type=[[Oauth2Type alloc] initWithOauthType:oauthType];
    [userDefault removeObjectForKey:oauth2Type.accessTokenName];
    [userDefault removeObjectForKey:oauth2Type.accessTokenExpiresName];
    [userDefault removeObjectForKey:oauth2Type.accessUidName];
    [oauth2Type release];
}

- (void) didCloseButtonClick:(id)sender
{
    [self close];
}


- (void) getUserInfo
{
    //如果已经登陆了，则调用请求用户数据
    if([Oauth2ViewController isLogin:self.oauthType])
    {
        switch (self.oauthType) {
            case OauthTypeSinaWeibo:
            {
                [self startAsynchronousRequest:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",[Oauth2ViewController uid:self.oauthType],[Oauth2ViewController accessToken:self.oauthType]] delegate:self didFinishRequest:@selector(didFinishRequestUserInfo:) didFailedRequest:@selector(didFailRequestUserInfo:)];
            }
                break;
            case OauthTypeTencentWeibo:
            {
                [self startAsynchronousRequest:[NSString stringWithFormat:@"http://open.t.qq.com/api/user/info?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a",self.type.appId,[Oauth2ViewController accessToken:self.oauthType],[Oauth2ViewController uid:self.oauthType]] delegate:self didFinishRequest:@selector(didFinishRequestUserInfo:) didFailedRequest:@selector(didFailRequestUserInfo:)];
            }
                break;
            case OauthTypeQQ:
            {
                [self startAsynchronousRequest:[NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@",self.type.appId,[Oauth2ViewController accessToken:self.oauthType],[Oauth2ViewController uid:self.oauthType]] delegate:self didFinishRequest:@selector(didFinishRequestUserInfo:) didFailedRequest:@selector(didFailRequestUserInfo:)];
            }
                break;
            case OauthTypeRenren:
            {
                //获得用户uid
                NSMutableDictionary *muDic=[NSMutableDictionary dictionary];
                
                [muDic setObject:@"users.getInfo" forKey:@"method"];
                [muDic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [muDic setObject:@"1.0" forKey:@"v"];
                [muDic setObject:@"JSON" forKey:@"format"];
                [muDic setObject:[Oauth2ViewController uid:self.oauthType] forKey:@"uids"];
                [muDic setObject:[self ecodeRenrenSig:muDic secret:self.type.appSecret] forKey:@"sig"];
                
                [self startSynchronousPostRequest:@"http://api.renren.com/restserver.do" postData:muDic delegate:self didFinishRequest:@selector(didFinishRequestUserInfo:) didFailedRequest:@selector(didFailRequestUserInfo:)];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
        {
            [self.delegate oauthRequestFailed:self returnCode:OauthRequestGetUserInfo returnMessage:@"用户未授权"];
        }
    }
}
- (void) shareStatus:(NSString *)shareStr
{
    //如果已经登陆了，则调用请求用户数据
    if([Oauth2ViewController isLogin:self.oauthType])
    {
        switch (self.oauthType) {
            case OauthTypeSinaWeibo:
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [dic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [dic setObject:shareStr forKey:@"status"];
                
                [self startSynchronousPostRequest:@"https://api.weibo.com/2/statuses/update.json" postData:dic delegate:self didFinishRequest:@selector(didFinishRequestShareStatus:) didFailedRequest:@selector(didFailRequestShareStatus:)];
            }
                break;
            case OauthTypeTencentWeibo:
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [dic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [dic setObject:shareStr forKey:@"content"];
                //下面四个属性腾讯微博借口基本都要传入这些参数
                [dic setObject:@"json" forKey:@"format"];
                [dic setObject:self.type.appId forKey:@"oauth_consumer_key"];
                [dic setObject:@"2.a" forKey:@"oauth_version"];
                [dic setObject:[Oauth2ViewController uid:self.oauthType] forKey:@"openid"];
                
                [self startSynchronousPostRequest:@"https://open.t.qq.com/api/t/add" postData:dic delegate:self didFinishRequest:@selector(didFinishRequestShareStatus:) didFailedRequest:@selector(didFailRequestShareStatus:)];
            }
                break;
            case OauthTypeRenren:
            {
                //获得用户uid
                NSMutableDictionary *muDic=[NSMutableDictionary dictionary];
                
                [muDic setObject:@"status.set" forKey:@"method"];
                [muDic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [muDic setObject:shareStr forKey:@"status"];
                [muDic setObject:@"1.0" forKey:@"v"];
                [muDic setObject:@"JSON" forKey:@"format"];
                [muDic setObject:[self ecodeRenrenSig:muDic secret:self.type.appSecret] forKey:@"sig"];
                
                [self startSynchronousPostRequest:@"http://api.renren.com/restserver.do" postData:muDic delegate:self didFinishRequest:@selector(didFinishRequestShareStatus:) didFailedRequest:@selector(didFailRequestShareStatus:)];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
        {
            [self.delegate oauthRequestFailed:self returnCode:OauthRequestGetUserInfo returnMessage:@"用户未授权"];
        }
    }
}
- (void) shareStatusWithImage:(NSString *)shareStr image:(UIImage *)image
{
    //如果已经登陆了，则调用请求用户数据
    if([Oauth2ViewController isLogin:self.oauthType])
    {
        switch (self.oauthType) {
            case OauthTypeSinaWeibo:
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [dic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [dic setObject:shareStr forKey:@"status"];
                
                NSDictionary *data=[NSDictionary dictionaryWithObject:UIImagePNGRepresentation(image) forKey:@"pic"];
                
                [self startSynchronousPostRequestWithData:@"https://upload.api.weibo.com/2/statuses/upload.json" postValue:dic postData:data didFinishRequest:^(ASIHTTPRequest *request) {
                    [self didFinishRequestShareStatusWithImage:request];
                } didFailedRequest:^(ASIHTTPRequest *request) {
                    [self didFailRequestShareStatusWithImage:request];
                }];
            }
                break;
            case OauthTypeTencentWeibo:
            {
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [dic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [dic setObject:shareStr forKey:@"content"];
                //下面四个属性腾讯微博借口基本都要传入这些参数
                [dic setObject:@"json" forKey:@"format"];
                [dic setObject:self.type.appId forKey:@"oauth_consumer_key"];
                [dic setObject:@"2.a" forKey:@"oauth_version"];
                [dic setObject:[Oauth2ViewController uid:self.oauthType] forKey:@"openid"];
                
                NSDictionary *data=[NSDictionary dictionaryWithObject:UIImagePNGRepresentation(image) forKey:@"pic"];
                
                [self startSynchronousPostRequestWithData:@"https://open.t.qq.com/api/t/add_pic" postValue:dic postData:data didFinishRequest:^(ASIHTTPRequest *request) {
                    [self didFinishRequestShareStatusWithImage:request];
                } didFailedRequest:^(ASIHTTPRequest *request) {
                    [self didFailRequestShareStatusWithImage:request];
                }];
            }
                break;
            case OauthTypeRenren:
            {
                //获得用户uid
                NSMutableDictionary *muDic=[NSMutableDictionary dictionary];
                
                [muDic setObject:@"photos.upload" forKey:@"method"];
                [muDic setObject:shareStr forKey:@"caption"];
                
                [muDic setObject:[Oauth2ViewController accessToken:self.oauthType] forKey:@"access_token"];
                [muDic setObject:@"1.0" forKey:@"v"];
                [muDic setObject:@"JSON" forKey:@"format"];
                [muDic setObject:[self ecodeRenrenSig:muDic secret:self.type.appSecret] forKey:@"sig"];
                
                NSDictionary *postData=[NSDictionary dictionaryWithObject:UIImagePNGRepresentation(image) forKey:@"upload"];
                //                [self startSynchronousPostRequestWithData:@"http://api.renren.com/restserver.do" postValue:muDic postData:[NSDictionary dictionaryWithObject:UIImagePNGRepresentation(image) forKey:@"upload"] didFinishRequest:^(ASIHTTPRequest *request) {
                //                    [self didFinishRequestShareStatusWithImage:request];
                //                } didFailedRequest:^(ASIHTTPRequest *request) {
                //                    [self didFailRequestShareStatusWithImage:request];
                //                } ];
                
                ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://api.renren.com/restserver.do"]];
                for(NSString *key in muDic.keyEnumerator)
                {
                    [request setPostValue:[muDic objectForKey:key] forKey:key];
                }
                for(NSString *key in postData.keyEnumerator)
                {
                    [request addData:[postData objectForKey:key] withFileName:@"key.png" andContentType:@"image/png"  forKey:key];
                }
                request.timeOutSeconds=TIME_OUT_SECOND;
                [request startSynchronous];
                NSLog(@"%@",request.responseString);
                if([self isRequestSucceed:request])
                    [self didFinishRequestShareStatusWithImage:request];
                else
                    [self didFailRequestShareStatusWithImage:request];
                
            }
                break;
            default:
                break;
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
        {
            [self.delegate oauthRequestFailed:self returnCode:OauthRequestGetUserInfo returnMessage:@"用户未授权"];
        }
    }
}
//人人调用方法需要用的一个参数,secret是appSecret，创建应用的时候和appId一起的。
- (NSString *)ecodeRenrenSig:(NSDictionary *)dic secret:(NSString *)secret
{
    NSMutableString *muStr=[NSMutableString string];
    //将dic中的参数按照key的首字母排序
    NSMutableArray *array=[NSMutableArray array];
    
    for(NSString *key in dic.keyEnumerator)
    {
        [array addObject:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
    }
    NSSortDescriptor *brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    for(int i=0;i<sortedArray.count;i++)
    {
        NSString *key=[[sortedArray objectAtIndex:i] objectForKey:@"key"];
        [muStr appendFormat:@"%@=%@",key,[dic objectForKey:key]];
    }
    [muStr appendString:secret];
    
    return [CommonHelper encodeMD5:muStr];
}
#pragma mark - 异步网络连接回调
- (void) didFinishRequestUserInfo:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFinished:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFinished:self returnCode:OauthRequestGetUserInfo returnMessage:request.responseString];
    }
}
- (void) didFailRequestUserInfo:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFailed:self returnCode:OauthRequestGetUserInfo returnMessage:@"网络异常"];
    }
}

- (void) didFinishRequestShareStatus:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFinished:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFinished:self returnCode:OauthRequestShareStatus returnMessage:request.responseString];
    }
}
- (void) didFailRequestShareStatus:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFailed:self returnCode:OauthRequestShareStatus returnMessage:@"网络异常"];
    }
}

- (void) didFinishRequestShareStatusWithImage:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFinished:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFinished:self returnCode:OauthRequestShareWithImage returnMessage:request.responseString];
    }
}
- (void) didFailRequestShareStatusWithImage:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(oauthRequestFailed:returnCode:returnMessage:)])
    {
        [self.delegate oauthRequestFailed:self returnCode:OauthRequestShareWithImage returnMessage:@"网络异常"];
    }
}


@end
