//
//  MLoadingView.m
//  LoadingTest
//
//  Created by  on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MLoadingView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MLoadingView

@synthesize acView,tipLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
//        [self addSubview:backView];
        
        
        
        
        acView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-200)/2, (frame.size.height-120)/2, 200, 90)];
        acView.backgroundColor = [UIColor blackColor];
        acView.layer.cornerRadius =8;
        [self addSubview:acView];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10,(acView.frame.size.height-40)/2,40,40)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.tag = 300;
        indicator.hidesWhenStopped = YES;
        indicator.backgroundColor = [UIColor clearColor];
        [acView addSubview:indicator];
     
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 90, 80)];
        tipLabel.adjustsFontSizeToFitWidth = NO;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        tipLabel.opaque = NO;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:16];
        [acView addSubview:tipLabel];
    }
    return self;
}


-(void) showLoadingView:(NSString *)tip
{
    self.hidden = NO;
    
    /*
     
     
     1.千保健，万保健，心态平衡是关键。
     3.要活好，心别小；善制怒，寿无数。
     4.心胸宽大能撑船，健康长寿过百年。
     5.要想健康快乐，学会自己找乐。
     12.笑一笑，十年少。
     13.一日三笑，人生难老。
     14.笑口常开，青春常在。
     18.先睡心，后睡眼。
     19.药补食补，不如心补。
     20.饭养人，歌养心。
     21.早吃好，午吃饱，晚吃巧。
     22.暴饮暴食会生病，定时定量可安宁。
     24.若要身体壮，饭菜嚼成浆。
     25.若要百病不生，常带饥饿三分。
     27.每餐留一口，活到九十九。
     
     
     */
    
    NSArray *temarr = [NSArray arrayWithObjects:@"千保健，万保健心态平衡是关键",@"要活好，心别小善制怒，寿无数",@"心胸宽大能撑船健康长寿过百年",@"要想健康快乐学会自己找乐",@"笑一笑，十年少",@"一日三笑人生难老",@"笑口常开青春常在",@"先睡心，后睡眼",@"饭养人，歌养心",@"早吃好，午吃饱，晚吃巧",@"暴饮暴食会生病定时定量可安宁",@"若要身体壮饭菜嚼成浆",@"若要百病不生常带饥饿三分",@"每餐留一口活到九十九",@"药补食补不如心补", nil];
    
    int tag = arc4random()%15;
    
    if (tag == 0) {
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 1){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 2){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 3){
        tipLabel.frame = CGRectMake(60, 5, 110, 80);
    }else if (tag == 4){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 5){
        tipLabel.frame = CGRectMake(80, 5, 70, 80);
    }else if (tag == 6){
        tipLabel.frame = CGRectMake(80, 5, 70, 80);
    }else if (tag == 7){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 8){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 9){
        tipLabel.frame = CGRectMake(60, 5, 90, 80);
    }else if (tag == 10){
        tipLabel.frame = CGRectMake(60, 5, 120, 80);
    }else if (tag == 11){
        tipLabel.frame = CGRectMake(70, 5, 90, 80);
    }else if (tag == 12){
        tipLabel.frame = CGRectMake(60, 5, 110, 80);
    }else if (tag == 13){
        tipLabel.frame = CGRectMake(70, 5, 90, 80);
    }else if (tag == 14){
        tipLabel.frame = CGRectMake(80, 5, 70, 80);
    }
    
    
    tipLabel.text = [temarr objectAtIndex:tag];
//    tipLabel.text = @"常吃萝卜菜啥病不用管";
    
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[acView viewWithTag:300];
	[indicator startAnimating];	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


-(void) hiddenLoadingView
{
    self.hidden = YES;
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[acView viewWithTag:300];
	[indicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



-(void) setAcViewFrame:(CGRect)rect
{
    if(acView)
    acView.frame = rect;
}




//加载成功提示:

-(void) loadSuccessTip:(NSString *)tip
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[acView viewWithTag:300];
	[indicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    tipLabel.text = tip;
    
    [self performSelector:@selector(hiddenAcView:) withObject:nil afterDelay:1.0];
}


-(void) hiddenAcView:(id)sender
{
    self.hidden =YES;
}


 



@end
