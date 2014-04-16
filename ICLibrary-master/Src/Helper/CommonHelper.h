//
//  CommonHelper.h
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject


#pragma mark - 普通工具方法
+ (void)showHUDWithText:(NSString *)text;//文字提示框
+ (NSString *)getWebImageUrl:(NSString *)url;//获取网络图片绝对地址
+ (NSString *) encodeMD5:(NSString *)str;//将普通字符串加密成md5
+ (BOOL)isFirstLaunched;//判断是否第一次运行
+ (id)performSelector:(id)delegate aSelector:(SEL)aSelector withMultiObjects:(id)object,...;//多参数performSelector


#pragma mark - Cache Data
//将对象压缩存入本地，存入和取得操作
+ (void)saveObjectToLocal:(NSString *)key obj:(id)obj;
+ (id)getObjectFromLocal:(NSString *)key;

#pragma mark - NetWork Statue
//判断网络和服务器是否有连接
+ (BOOL)isConnectedToNetwork;
+ (BOOL)isServerCanConnected;

#pragma mark - 用户相关
+ (BOOL)isLogin;//判断用户是否登陆
+ (void)saveCurrentUser:(id)dic; //将用户数据保存在本地
+ (id)getCurrentUser; //取出当前保存的用户信息，如果无，则返回nil
+ (NSString *)getCurrentUserMemberID; //获取当前用户会员ID
+ (NSString *)getCurrentUserName; //获取当前用户名称
+ (NSString *)getCurrentUserPassword;//获取当前用户的密码
+ (NSString *)getCurrentUserPoint;//获得当前的积分
+ (void)saveCurrentUserPassword:(NSString *)newPassword;  //保存当前用户密码
+ (void) logoff; //当前用户注销


#pragma mark - 公共控件处理
+ (void)setCommonButton:(UIButton *)button withTitle:(NSString *)title;
+ (void)setCommonRedButton:(UIButton *)button withTitle:(NSString *)title;
//淡入淡出
+(void)HiddenView:(UIView *)view To:(CGRect)frame During:(float)time delegate:(id)delegate;
+(void)ShowView:(UIView *)view To:(CGRect)frame During:(float)time delegate:(id)delegate;

//图片自适应,在rect区域内自适应size大小
+ (CGRect)fitSizeWithRect:(CGRect )rect withSize:(CGSize )size isWidthPriority:(BOOL )isWidthPriority;
+ (void)loadLogoImage:(UIImageView *)logo WithURL:(NSURL *)imageUrl inRect:(CGRect )rect;

#pragma mark - Validate
+ (BOOL)isMobilStringValidate:(NSString *)mobile;//验证登陆注册等时输入框的内容是否合法

#pragma mark - 获取应用程序版本，IMSI和UUID
+ (float)getApplictionVersion;
+ (void )getIMSI;
+ (NSString *)getUUID;//生成32位uid


#pragma mark - 公共路径
+ (NSString *)getDownLoadHomeDirectory;
+ (NSString *)getMyFaveHomeDirectory;
+ (BOOL)isDirectoryExist:(NSString *)path;
+ (BOOL)deleteBookByID:(NSString *)bookID;
+ (void)creatDataDircerty;

#pragma mark - 缓存处理
+ (BOOL)isExistCacheData;
+ (void)clearCacheData;

#pragma mark - 截屏，去除上下导航栏
+ (UIImage *)getShareImage:(UIViewController *)viewController;
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;

#pragma mark - 新浪和腾讯微博是否登录，注销登录
+ (BOOL)isSinaWBLogin;
+ (BOOL)isTencentLogin;
+ (void)sinaWBLoginOut;
+ (void)tencentWBLoginOut;
+ (NSString *)getSinaWBToken;
+ (NSString *)getTencentWBToken;
+ (NSString *)getTencentOpenID;


#pragma mark - 文字调整
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;


@end
