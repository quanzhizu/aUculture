//
//  ICShowView.m
//  iChanceSample
//
//  Created by Fox on 13-2-6.
//
//

#import "ICShowView.h"

@implementation ICShowView

//弹出MB对话框，过一段时间结束
+ (void)showMBAlertView:(UIView *) currentView
                message:(NSString *) message
               duration:(float) duration
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:currentView];
    [currentView addSubview:hud];
    [hud setMode:MBProgressHUDModeText];
    hud.labelText=message;
    hud.margin=10.f;
    hud.yOffset=10.f;
    hud.removeFromSuperViewOnHide=YES;
    [hud show:YES];
    [hud hide:YES afterDelay:duration];
    [hud release];
}

//弹出MB对话框，过一段时间结束,完成执行
+ (void) showMBAlertView:(UIView *) currentView
                 message:(NSString *) message
                duration:(float) duration
         completionBlock:(dispatch_block_t) completion
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:currentView];
    [currentView addSubview:hud];
    [hud setMode:MBProgressHUDModeText];
    hud.labelText=message;
    hud.margin=10.f;
    hud.yOffset=10.f;
    [hud showAnimated:NO whileExecutingBlock:^{
        sleep(duration);
    } completionBlock:^{
        [hud removeFromSuperview];
        [hud release];
        completion();
    }];
}

//弹出MB对话框，可以有多个阶段
+ (void) showMBAlertView:(UIView *) currentView firstStage:(dispatch_stage_block_t) firstStage, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, firstStage); // scan for arguments after firstObject.
    NSMutableArray *array=[NSMutableArray array];
    for (dispatch_stage_block_t stage = firstStage; stage != nil; stage = va_arg(args,dispatch_stage_block_t))
    {
        [array addObject:stage];
    }
    va_end(args);
    
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:currentView];
    [currentView addSubview:hud];
    [hud setMode:MBProgressHUDModeText];
    hud.margin=10.f;
    hud.yOffset=10.f;
    hud.removeFromSuperViewOnHide=YES;
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:array forKey:@"stages"];
    [dic setObject:hud forKey:@"hud"];
    
    [hud showWhileExecuting:@selector(mbMixTask:) onTarget:self withObject:dic animated:YES];
    [hud release];
}

//弹出MB对话框，在方法执行期间显示
+ (void) showMBAlertView:(UIView *) currentView message:(NSString *) message whileExecutingBlock:(dispatch_block_t)block completionBlock:(dispatch_block_t) completion
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:currentView];
    hud.labelText=message;
    [currentView addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:block completionBlock:^{
        [hud removeFromSuperview];
        [hud release];

        completion();
    }];
}




@end
