//
//  NSTimer+Addition.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
