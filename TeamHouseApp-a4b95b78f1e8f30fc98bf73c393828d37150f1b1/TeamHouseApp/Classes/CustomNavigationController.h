//
//  CustomNavigationController.h
//  ITWisdomCommunity
//
//  Created by Renbing on 13-10-17.
//  Copyright (c) 2013年 lirenbing@inspiry.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface CustomNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSDictionary * mydict;
    NSString *liufaliang;
}
@end
