//
//  CommonHelper.m
//  iChanceSample
//
//  Created by Fox on 12-12-6.
//
//

#import "CommonHelper.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppSession.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "AppleReachability.h"
#import "SDWebImageManager.h"


#define PRIVATE_PATH "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"


#define DOWNLOADTHREADS    @"DownloadThreads"


@implementation CommonHelper



#pragma mark - 输入参数获得网络POST数据
+ (NSString *)getPostData:(NSString *)beanName
               methodName:(NSString *)methodName
                  appCode:(NSString *)appCode
                   params:(NSDictionary *)params
{
    
    
    NSArray *userArray = [NSArray arrayWithObjects:params, nil];
    NSDictionary *sendInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"001",@"imei",
                              @"002",@"imsi",
                              @"iphone",@"os",
                              userArray,@"param", nil];
    
    NSArray *sendArray = [NSArray arrayWithObjects:sendInfo, nil];
    NSDictionary *allInfo = [NSDictionary dictionaryWithObjectsAndKeys:beanName,@"beanName",
                             methodName,@"methodName",
                             appCode,@"appcode",
                             sendArray,@"params",nil];
    
    return [NSString stringWithFormat:@"%@",[allInfo JSONString]];
}


+ (void )getIMSI
{
    
    /*
     CTTelephonyNetworkInfo *teleNetworkInfo = [[[CTTelephonyNetworkInfo alloc] init] retain];
     CTCarrier *carrier = teleNetworkInfo.subscriberCellularProvider;
     NSLog(@"%@", carrier.carrierName);
     NSString *isoCountryCode = [NSString stringWithFormat:@"%@", carrier.isoCountryCode];
     NSLog(@"%@", isoCountryCode);
     NSString *mobileCountryCode = [NSString stringWithFormat:@"%@", carrier.mobileCountryCode];
     NSLog(@"%@", mobileCountryCode);
     NSString *mobileNetworkCode = [NSString stringWithFormat:@"%@", carrier.mobileNetworkCode];
     NSLog(@"%@", mobileNetworkCode);
     
     // 操作系统名称与版本号
     NSString *os = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[NSProcessInfo processInfo] operatingSystemVersionString]];
     NSLog(@"%@",os);
     // 设备类型
     size_t size;
     sysctlbyname("hw.machine", NULL, &size, NULL, 0);
     char *machine = malloc(size);
     sysctlbyname("hw.machine", machine, &size, NULL, 0);
     NSString *model = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
     
     free(machine);
     
     */
}

#pragma mark - 普通工具方法
+ (void)showHUDWithText:(NSString *)text
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    [HUD setMode:MBProgressHUDModeText];
    HUD.labelText = text;
    HUD.margin = 10.f;
	HUD.yOffset = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0];
    [HUD release];
}



#pragma mark - Cache Data
+ (void)saveObjectToLocal:(NSString *)key obj:(id)obj{
    if(key.length>0)
    {
        if(obj!=nil)
        {
            NSData *data=[NSKeyedArchiver archivedDataWithRootObject:obj];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }
}

+ (id)getObjectFromLocal:(NSString *)key{
    
    //将对象从本地取出，数据解压缩，和saveObjectToLocal的数据配套使用
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (id)performSelector:(id)delegate aSelector:(SEL)aSelector withMultiObjects:(id)object,...
{
    //返回值
    id anObject = nil;
    
    @autoreleasepool {
        //获取方法信息
        NSMethodSignature *signature = [delegate methodSignatureForSelector:aSelector];
        
        //判断方法信息是否存在
        if(signature){
            
            //创建方法调用方法
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            //设置方法调用类
            [invocation setTarget:delegate];
            
            //设置方法
            [invocation setSelector:aSelector];
            
            //获取方法参数长度
            NSUInteger len = signature.numberOfArguments;
            
            //如果参数的个数大于1（len >2,0为方法拥者，1，为方法名)
            if(len > 2){
                //用于获取参数的值的变量
                id value = object;
                
                //参数列表变量
                va_list arguments;
                
                //通知参数列表开始获取参数
                va_start(arguments, object);
                
                //循环添加方法相应的参数
                for(int i = 2; i < len; i++){
                    
                    //添加参数
                    [invocation setArgument:&value atIndex:i];
                    
                    //获取新的参数
                    if(value != nil){
                        value = va_arg(arguments, id);
                    }
                }
                
                //通知参数列表结束参数获取
                va_end(arguments);
            }
            
            //执行方法
            [invocation invoke];
            
            //判断方法的返回值
            if(signature.methodReturnLength == 1){
                [invocation getReturnValue:&anObject];
            }
        }
    }
    return anObject;
}
+ (NSString *)getWebImageUrl:(NSString *)url
{
    if (url == nil) {
        url = @"";
    }
    return [IMAGEBASEURL stringByAppendingString:url];
}

+ (NSString *)getUUID
{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}


+ (NSString *) encodeMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}


#pragma mark - NetWork Statue
+ (BOOL) isConnectedToNetwork
{
    //参考来源：http://www.devdiv.com/forum.php?mod=viewthread&tid=31724
    
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (BOOL)isServerCanConnected
{
    BOOL isExistenceNetwork = TRUE;
	AppleReachability *r = [AppleReachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork = FALSE;
            //NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork = TRUE;
            //NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork = TRUE;
            //NSLog(@"正在使用wifi网络");
            break;
    }
	return isExistenceNetwork;
}

#pragma mark - 用户相关
/**
 * @brief 判断用户是否登陆
 */
+ (BOOL)isLogin
{
    id currentUser = [CommonHelper getObjectFromLocal:@"currentUser"];
    if(currentUser==nil)
        return NO;
    else
        return YES;
}
/**
 * @brief 将用户数据保存在本地
 */
+ (void)saveCurrentUser:(id)dic
{
    [CommonHelper saveObjectToLocal:@"currentUser" obj:dic];
}
/**
 * @brief 取出当前保存的用户信息，如果无，则返回nil
 */
+ (id)getCurrentUser
{
    return [CommonHelper getObjectFromLocal:@"currentUser"];
}

+ (NSString *)getCurrentUserMemberID
{
    NSString *memberID = [NSString stringWithFormat:@"%@",[[self getCurrentUser] objectForKey:@"memberid"]];
    
    if (memberID.length == 0) {
        return @"";
    }
    
    return  memberID;
}

+ (NSString *)getCurrentUserName
{
    if (NO == [self isLogin]) {
        return @"";
    }
    
    NSString *userName = [NSString stringWithFormat:@"%@",[[self getCurrentUser] objectForKey:@"username"]];
    
    if (userName.length == 0) {
        return @"";
    }
    
    return  userName;
}


+ (NSString *)getCurrentUserPassword
{
    NSString *passWord = [NSString stringWithFormat:@"%@",[[self getCurrentUser] objectForKey:@"password"]];
    
    if (passWord.length == 0) {
        return @"";
    }
    
    return  passWord;
}


+ (NSString *)getCurrentUserPoint
{
    NSString *points = [NSString stringWithFormat:@"%@",[[self getCurrentUser] objectForKey:@"Point"]];
    
    if (points.length == 0) {
        return @"";
    }
    
    return  points;
}

+ (void)saveCurrentUserPassword:(NSString *)newPassword
{
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self getCurrentUserMemberID],@"memberid",
                         [self getCurrentUserName],@"username",newPassword ,@"password",[self getCurrentUserPoint],@"Point", nil];
    [CommonHelper saveCurrentUser:dic];
}


/**
 * @brief 当前用户注销
 */
+ (void) logoff
{
    [CommonHelper saveObjectToLocal:@"currentUser" obj:nil];
}



+ (void)setCommonButton:(UIButton *)button withTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"common_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"common_btn_press_bg" ofType:@"png"]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"common_btn_press_bg" ofType:@"png"]] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

+ (void)setCommonRedButton:(UIButton *)button withTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"actionsheet_btn" ofType:@"png"]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"actionsheet_btn2_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"actionsheet_btn2_press" ofType:@"png"]] forState:UIControlStateSelected];
}

+ (BOOL)isMobilStringValidate:(NSString *)mobile
{
    if (mobile.length != 11) {
        return FALSE;
    }
    
    if (![[mobile substringToIndex:1] isEqualToString:@"1"]) {
        return FALSE;
    }
    
    return TRUE;
    
}


#pragma mark - 淡入淡出
+(void)HiddenView:(UIView *)view To:(CGRect)frame During:(float)time delegate:(id)delegate{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:time];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if(delegate !=nil &&[delegate respondsToSelector:@selector(onAnimationComplete:finished:context:)]){
		[UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
		[UIView setAnimationDelegate:delegate];
	}
	view.frame = frame;
	view.alpha = 0.0;
	[UIView commitAnimations];
}

+(void)ShowView:(UIView *)view To:(CGRect)frame During:(float)time delegate:(id)delegate{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:time];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if(delegate !=nil &&[delegate respondsToSelector:@selector(onAnimationComplete:finished:context:)]){
		[UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
		[UIView setAnimationDelegate:delegate];
	}
	view.hidden = NO;
	view.alpha = 1.0;
	view.frame = frame;
	[UIView commitAnimations];
}

#pragma mark - 自适应
+ (CGRect)fitSizeWithRect:(CGRect )rect withSize:(CGSize )size isWidthPriority:(BOOL )isWidthPriority
{
    //rect为总的显示区域，size为实际的大小，isWidthPriority是否宽度优先
    
    //自适应的区域
    float fit_width = rect.size.width;
    float fit_height = rect.size.height;
    
    //实际大小
    float actual_width = size.width;
    float actual_height = size.height;
    
    //自适应后的宽和高
    float width = 0;
    float height = 0;
    
    //先判断是以高度来自适应还是以宽度来自适应
    if (isWidthPriority) {
        //高度固定，宽度自适应
        height = fit_height;
        width = fit_height*actual_width/actual_height;
    }else{
        //宽度固定，高度自适应
        width = fit_width;
        height = fit_width*actual_height/actual_width;
    }
    
    return CGRectMake(rect.origin.x, rect.origin.y, width, height);
}


+ (void)loadLogoImage:(UIImageView *)logo WithURL:(NSURL *)imageUrl inRect:(CGRect )rect
{
    //在rect区域内加载logo
    [[SDWebImageManager sharedManager] downloadWithURL:imageUrl delegate:self options:SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
        float logo_width = image.size.width / 2;
        float logo_height = image.size.height / 2;
        [logo setFrame:[CommonHelper fitSizeWithRect:rect withSize:CGSizeMake(logo_width, logo_height) isWidthPriority:YES]];
        logo.image = image;
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - 判断是否第一次登录
+ (BOOL)isFirstLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}


#pragma mark - 获取本地版本
+ (float)getApplictionVersion
{
    
    //    [NSString stringWithFormat:@"Version %@",
    //     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    //    [NSString stringWithFormat:@"Build %@",
    //     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
}


#pragma mark - 公共路径
+ (NSString *)getDownLoadHomeDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Data"];
}

+ (NSString *)getMyFaveHomeDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyFave"];
}

+ (BOOL)isDirectoryExist:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+ (BOOL)deleteBookByID:(NSString *)bookID
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bookHomePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/Data/%@",bookID];
    if (YES == [fileManager fileExistsAtPath:bookHomePath]  && [bookID length] > 0) {
        //删除目录下的所有文件
        [fileManager removeItemAtPath:bookHomePath error:&error];
        //[[WBBooksManager shareInstance] deleteContentForKey:bookID];
        return YES;
    }
    return NO;
}

+ (void)creatDataDircerty
{
    //判断Library/Caches/Data路径是否存在
    NSError *error;
    NSString *dataDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Data"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (NO == [fileManager fileExistsAtPath:dataDirectory isDirectory:(&isDir)]) {
        [[NSFileManager defaultManager]   createDirectoryAtPath: dataDirectory  withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //书籍收藏目录
    dataDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyFave"];
    isDir = YES;
    if (NO == [fileManager fileExistsAtPath:dataDirectory isDirectory:(&isDir)]) {
        [[NSFileManager defaultManager]   createDirectoryAtPath: dataDirectory  withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


#pragma mark - 缓存处理
+ (BOOL)isExistCacheData
{
    //判断Data目录下是够存在书籍目录
    NSString *documentDir = [CommonHelper getDownLoadHomeDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSMutableArray *fileList = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentDir error:&error]];
    
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    int bookNumber = [fileList count];
    for (int i= bookNumber - 1; i >= 0; i--) {
        NSString *file = [fileList objectAtIndex:i];
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            //存在目录，即缓存存在
            return YES;
        }
        isDir = NO;
    }
    
    return NO;
    
}

+ (void)clearCacheData
{
    //清除Data目录下的目录（每个目录是一本书籍）
    //判断Data目录下是够存在书籍目录
    NSString *documentDir = [CommonHelper getDownLoadHomeDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSMutableArray *fileList = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentDir error:&error]];
    
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    int bookNumber = [fileList count];
    for (int i= bookNumber - 1; i >= 0; i--) {
        NSString *file = [fileList objectAtIndex:i];
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            //存在目录，则删除缓存
            [fileManager removeItemAtPath:path error:&error];
        }
    }
    
    
}


+ (UIImage *)getShareImage:(UIViewController *)viewController
{
    UIGraphicsBeginImageContext(viewController.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(CGRectMake(0, 65, 1024, 618));
    [viewController.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Data"];
    NSString *imagePath = [NSString stringWithFormat:@"%@/temp.png",documentsDirectory];
    
    if (YES == [CommonHelper writeImage:theImage toFileAtPath:imagePath]) {
        UIGraphicsEndImageContext();
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    
    UIGraphicsEndImageContext();
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            // the rest, we write to jpeg
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    
    return NO;
}


#pragma mark - 微博登录登出
+ (BOOL)isSinaWBLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"] != nil) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTencentLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tencent_access_token"] != nil) {
        return YES;
    }
    return NO;
}
+ (void)sinaWBLoginOut
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sina_access_token"];
}
+ (void)tencentWBLoginOut
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"tencent_access_token"];
}

+ (NSString *)getSinaWBToken
{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"]];
}
+ (NSString *)getTencentWBToken
{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tencent_access_token"]];
}

+ (NSString *)getTencentOpenID
{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"openid"]];
}



#pragma mark - 文字调整
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


@end
