//
//  Oauth2Type.h
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import <Foundation/Foundation.h>

typedef enum OauthType{
    OauthTypeTaoBao,                //淘宝,未写
    OauthTypeSinaWeibo,             //新浪微博
    OauthTypeQQ,                    //QQ空间,qq空间发表说说、上传图片需要申请接口，暂时还没写
    OauthTypeTencentWeibo,          //腾讯微博
    OauthTypeRenren,                //人人分享
    OauthTypeWeixin,                //微信
    OauthTypePengyouQuan            //朋友圈
} OauthType;


@interface Oauth2Type : NSObject
@property (nonatomic,copy) NSString *appId;             //appId
@property (nonatomic,copy) NSString *appSecret;         //appSecret
@property (nonatomic,copy) NSString *appRedirect;       //app 回调地址
@property (nonatomic,copy) NSString *authorUrlStr;      //app 授权页面
@property (nonatomic,copy) NSString *accessTokenName;   //app 存的token名
@property (nonatomic,copy) NSString *accessTokenExpiresName;//apptoken存的过期时间名
@property (nonatomic,copy) NSString *accessUidName;     //授权用户的uid名字


- (Oauth2Type *) initWithOauthType:(OauthType)type;
+ (Oauth2Type *) type:(OauthType)oauthType;

@end
