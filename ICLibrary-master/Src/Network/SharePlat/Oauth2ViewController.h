//
//  Oauth2ViewController.h
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import <UIKit/UIKit.h>
#import "ICViewController.h"
#import "Oauth2Type.h"

typedef enum OauthRequest{
    OauthRequestNone,               //其他回调，网络故障什么的返回此值
    OauthRequestAccessToken,        //授权成功后获得用户回调返回此值
    OauthRequestGetUserInfo,        //调用获取个人信息接口返回
    OauthRequestShareStatus,        //调用分享状态接口返回
    OauthRequestShareWithImage,     //调用分享有图片的状态返回
} OauthRequest;

@class Oauth2ViewController;
@protocol Oauth2Delegate <NSObject>
@optional
- (void) oauthRequestFinished:(Oauth2ViewController *)oauth2View
                   returnCode:(OauthRequest)returnCode
                returnMessage:(NSString *)returnMessage;

- (void) oauthRequestFailed:(Oauth2ViewController *)oauth2View
                 returnCode:(OauthRequest)returnCode
              returnMessage:(NSString *)returnMessage;
@end


@interface Oauth2ViewController : ICViewController<UIWebViewDelegate>

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) UIButton *cancelButton;        //取消按钮
@property (nonatomic,retain) Oauth2Type *type;              //这个的类型对象
@property (nonatomic) OauthType oauthType;                  //要使用的oauth验证类型,默认新浪微博
@property (nonatomic,assign) id<Oauth2Delegate> delegate;
@property (nonatomic,assign) UIView *target;                //父视图

- (id) initWithFrame:(CGRect)frame _oauthType:(OauthType)_oauthType;//初始化方法
- (id) initWithType:(OauthType)_oauthType;                          //默认全屏
- (void) show;                                                      //视图显示，默认不出现视图
- (void) close;                                                     //取消此窗口

- (void) getUserInfo;                                               //同步获得此用户的个人信息
- (void) shareStatus:(NSString *)shareStr;                          //同步分享一条状态
- (void) shareStatusWithImage:(NSString *)shareStr image:(UIImage *)image;//同步分享一条带图片的状态


+ (BOOL) isLogin:(OauthType)_oauthType;//判断self.oauthType指定的第三方是否已经登陆过
+ (NSString *)accessToken:(OauthType)_oauthType;//获得oauthType指定的accessToken，如果accessToken没有或者过期，则返回nil
+ (NSString *)uid:(OauthType)_oauthType;//返回oauthType指定的uid值，如果uid没有或者过期，则返回nil

+ (void) removeAllTokenInfo;//清除所有类型的token数据
+ (void) removeTokenInfoByType:(OauthType) _oauthType;//清空指定的类型的token数据

@end
