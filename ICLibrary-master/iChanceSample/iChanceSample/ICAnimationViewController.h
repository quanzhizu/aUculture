//
//  ICAnimationViewController.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICBaseViewController.h"
#import "ICTableViewController.h"

/* 过渡效果
 fade     //交叉淡化过渡(不支持过渡方向)
 push     //新视图把旧视图推出去
 moveIn   //新视图移到旧视图上面
 reveal   //将旧视图移开,显示下面的新视图
 cube     //立方体翻滚效果
 oglFlip  //上下左右翻转效果
 suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
 rippleEffect //滴水效果(不支持过渡方向)
 pageCurl     //向上翻页效果
 pageUnCurl   //向下翻页效果
 cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
 cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
 */

/* 过渡方向
 fromRight;
 fromLeft;
 fromTop;
 fromBottom;
 */

/*
 CATransition *animation = [CATransition animation];
 animation.delegate = self;
 animation.duration = 0.5f; //动画时长
 animation.timingFunction = UIViewAnimationCurveEaseInOut;
 animation.fillMode = kCAFillModeForwards;
 animation.type = @"cube"; //过度效果
 animation.subtype = @"formLeft"; //过渡方向
 animation.startProgress = 0.0 //动画开始起点(在整体动画的百分比)
 animation.endProgress = 1.0;  //动画停止终点(在整体动画的百分比)
 animation.removedOnCompletion = NO;
 [self.view.layer addAnimation:animation forKey:@"animation"];
 */


@interface ICAnimationViewController : ICBaseViewController


@end
