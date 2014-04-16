//
//  ICKeyChainHelper.h
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/**
 通常情况下，我们用NSUserDefaults存储数据信息，但是对于一些私密信息，
 比如密码、证书等等，就需要使用更为安全的keychain了。keychain里保存
 的信息不会因App被删除而丢失，在用户重新安装App后依然有效，数据还在。
 */

#import <Foundation/Foundation.h>

@interface ICKeyChainHelper : NSObject

/**
 * @brief   保存用户名和密码，保证在程序删除之后还存在
 */
+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameService 
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService;

/**
 * @brief   删除保存的用户名和密码
 */
+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService;

/**
 * @brief                   获得用户名
 * @param userNameService   用户名key
 */
+ (NSString*) getUserNameWithService:(NSString*)userNameService;


/**
 * @brief               获得密码
 * @param pwdService    密码key
 */
+ (NSString*) getPasswordWithService:(NSString*)pwdService;

@end
