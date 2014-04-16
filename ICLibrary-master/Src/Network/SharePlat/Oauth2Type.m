//
//  Oauth2Type.m
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import "Oauth2Type.h"

@implementation Oauth2Type
@synthesize appId;
@synthesize appRedirect;
@synthesize appSecret;
@synthesize accessTokenExpiresName;
@synthesize accessTokenName;
@synthesize accessUidName;
@synthesize authorUrlStr;


- (id)initWithOauthType:(OauthType)type
{
    self=[super init];
    if(self)
    {
        switch (type) {
            case OauthTypeSinaWeibo:
            {
                //新浪微博
                self.appId=@"2251093615";
                self.appSecret=@"a5f7325074adb6486c212f7f4a2239d6";
                self.appRedirect=@"http://www.cimu.com.cn";
                self.authorUrlStr=[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=token&redirect_uri=%@&display=mobile",self.appId,self.appRedirect];
                self.accessTokenName=@"accessTokenForWeibo";
                self.accessUidName=@"accessUidForWeibo";
                self.accessTokenExpiresName=@"accessTokenExpiresForWeibo";
            }
                break;
            case OauthTypeTencentWeibo:
            {
                //腾讯微博
                self.appId=@"801268994";
                self.appSecret=@"618e7f375574818e1a7c6cf67f5d7cc2";
                self.appRedirect=@"http://www.baidu.com";
                self.authorUrlStr=[NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=token&redirect_uri=%@",self.appId,self.appRedirect];
                NSLog(@"%@",self.authorUrlStr);
                self.accessTokenName=@"accessTokenForTencentWeibo";
                self.accessUidName=@"accessUidForTencentWeibo";
                self.accessTokenExpiresName=@"accessTokenExpiresForTencentWeibo";
            }
                break;
            case OauthTypeQQ:
            {
                //QQ空间
                self.appId=@"100339392";
                self.appSecret=@"baf6bee875b46f73512d84d05286af65";
                self.appRedirect=@"http://www.qq.com";
                self.authorUrlStr=[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/authorize?client_id=%@&response_type=token&redirect_uri=%@&display=mobile",self.appId,self.appRedirect];
                NSLog(@"%@",self.authorUrlStr);
                self.accessTokenName=@"accessTokenForQQ";
                self.accessUidName=@"accessUidForQQ";
                self.accessTokenExpiresName=@"accessTokenExpiresForQQ";
            }
                break;
            case OauthTypeWeixin:
            {
                //微信
                self.appId=@"wxdf669d84effd8b1c";
                self.appSecret=@"4eb601c01963b4ef96c313f0f8892a8e";
                self.appRedirect=@"http://www.baidu.com";
                //                self.authorUrlStr=[NSString stringWithFormat:@"https://open.weixin.qq.com/oauth?appid=%@&response_type=token",self.appId,self.appRedirect];
                self.accessTokenName=@"accessTokenForWeixin";
                self.accessUidName=@"accessUidForWeixin";
                self.accessTokenExpiresName=@"accessTokenExpiresForWeixin";
            }
                break;
            case OauthTypeRenren:
            {
                //人人
                self.appId=@"ccaa45ae45634458bbca407daa4aa03e";
                self.appSecret=@"a6eb72b931dd44dc80a4a89d1afb8f0a";
                self.appRedirect=@"http://graph.renren.com/oauth/login_success.html";//人人网默认提供此作为回调
                self.authorUrlStr=[NSString stringWithFormat:@"https://graph.renren.com/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=photo_upload,status_update",self.appId,self.appRedirect];
                self.accessTokenName=@"accessTokenForRenren";
                self.accessUidName=@"accessUidForRenren";
                self.accessTokenExpiresName=@"accessTokenExpiresForRenren";
            }
                break;
            default:
            {
                self.appId=@"";
                self.appSecret=@"";
                self.appRedirect=@"http:/www.cimu.com.cn";
                self.authorUrlStr=@"";
                self.accessTokenName=@"";
                self.accessUidName=@"";
                self.accessTokenExpiresName=@"";
            }
                break;
        }
    }
    return self;
}

+ (Oauth2Type *) type:(OauthType)oauthType
{
    return [[[Oauth2Type alloc] initWithOauthType:oauthType] autorelease];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n",self.appId,self.appSecret,self.appRedirect,self.authorUrlStr,self.accessTokenName,self.accessUidName,self.accessTokenExpiresName];
}




@end
