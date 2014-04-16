//
//  MLoadFailView.m
//  Portal
//
//  Created by  on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MLoadFailView.h"

@implementation MLoadFailView

@synthesize delegate;

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
//        UIImageView *failImg =[[UIImageView alloc] initWithFrame:CGRectMake(100, 80, 120, 120)];
//        failImg.backgroundColor =[UIColor clearColor];
//        failImg.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nullData" ofType:@"png"]];
//        [self addSubview:failImg];
        
//        self.backgroundColor = [UIColor clearColor];
        UIButton *failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        failBtn.frame = CGRectMake(100, 80, 120, 120);
        [failBtn setBackgroundImage:[UIImage imageNamed:@"nullData.png"] forState:UIControlStateNormal];
        [failBtn addTarget:self action:@selector(reloadDataClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:failBtn];
        
        
        
        UILabel *tpLabel1 =[[UILabel alloc] initWithFrame:CGRectMake(60, 210, 200, 30)];
        tpLabel1.backgroundColor =[UIColor clearColor];
        tpLabel1.textColor =[UIColor colorWithRed:.57 green:.57 blue:.57 alpha:1.0];
        tpLabel1.textAlignment =NSTextAlignmentCenter;
        tpLabel1.font =[UIFont boldSystemFontOfSize:19];
        tpLabel1.text =@"数据加载失败";
        [self addSubview:tpLabel1];         
        UILabel *tpLabel2 =[[UILabel alloc] initWithFrame:CGRectMake(30, 250, 260, 30)];
        tpLabel2.backgroundColor =[UIColor clearColor];
        tpLabel2.textColor =[UIColor colorWithRed:.46 green:.46 blue:.46 alpha:1.0];
        tpLabel2.textAlignment =NSTextAlignmentCenter;
        tpLabel2.font =[UIFont systemFontOfSize:15];
        tpLabel2.text =@"请检查您的网络并点击图片重新加载";
        [self addSubview:tpLabel2];
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)reloadDataClick
{
    if([delegate respondsToSelector:@selector(reloadData:)])
    {
        [delegate reloadData:nil];
    }    
}


 


@end
