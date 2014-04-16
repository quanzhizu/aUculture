//
//  Contents.h
//  TongChuanMobile
//
//  Created by 刘法亮 on 13-12-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#ifndef TongChuanMobile_Contents_h
#define TongChuanMobile_Contents_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TABBAR_OFFSET 55.5f


 
//测试服务器地址
#define SERVER_ADDRESS @"http://115.28.49.147:8080/fang/doJsonLogin.action"

#define SERVER_UserInfo @"http://115.28.49.147:8080/fang/doJsonUpdateUser.action"


 

#define SinaAppKey @"3860089843"
#define SinaAppSecret @"2229b13fac196faa23f3c5ac95e80d38"
#define SinaAppUrl @"http://www.intongchuan.com"
 
#define TencentAppKey @""
#define TencentAppSecret @""
#define TencentAppUrl @""
#endif
