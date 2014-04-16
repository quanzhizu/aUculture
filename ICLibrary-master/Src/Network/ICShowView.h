//
//  ICShowView.h
//  iChanceSample
//
//  Created by Fox on 13-2-6.
//
//

/*
 网络请求加载中效果
 */


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "UIAlertView+ICBlockAdditions.h"

typedef void (^dispatch_stage_block_t)(MBProgressHUD *hud);


@interface ICShowView : NSObject

//弹出MB对话框，过一段时间结束
+ (void)showMBAlertView:(UIView *) currentView
                message:(NSString *) message
               duration:(float) duration;

//弹出MB对话框，过一段时间结束,完成执行
+ (void) showMBAlertView:(UIView *) currentView
                 message:(NSString *) message
                duration:(float) duration
         completionBlock:(dispatch_block_t) completion;

//弹出MB对话框，可以有多个阶段
+ (void) showMBAlertView:(UIView *) currentView firstStage:(dispatch_stage_block_t) firstStage, ... NS_REQUIRES_NIL_TERMINATION;

//弹出MB对话框，在方法执行期间显示
+ (void) showMBAlertView:(UIView *) currentView message:(NSString *) message whileExecutingBlock:(dispatch_block_t)block completionBlock:(dispatch_block_t) completion;






@end
