//
//  ICSpanlishViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICSpanlishViewController.h"

@interface ICSpanlishViewController ()

@end

@implementation ICSpanlishViewController
@synthesize delegate;
@synthesize frameArr;
@synthesize radomArr;

#pragma mark - Memory manager
- (void)dealloc
{
    [frameArr release];
    [radomArr release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UIViewController life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        frameArr = [[NSMutableArray alloc] initWithCapacity:24];
        radomArr = [[NSMutableArray alloc] initWithCapacity:24];
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)viewDidLoad
{
    [self performSelectorOnMainThread:@selector(getRadomArr) withObject:nil waitUntilDone:YES];
    
    //添加24张图片
    for (int i = 0; i < 24; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0.5+80*(i%4), 1+80*(i/4), 79, 79)];
        img.tag = i+100;
        [self.view addSubview:img];
        [img release];
    }
    
    for (int i=0; i<frameArr.count; i++) {
        NSNumber *number = [frameArr objectAtIndex:i];
        UIImageView *img = (UIImageView *)[self.view viewWithTag:100+[number integerValue]];
        [self performSelector:@selector(FlipView:) withObject:img afterDelay:i/15.0];
    }
    
    [self performSelector:@selector(ShowLogo) withObject:nil afterDelay:3];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)stopAnimating
{
    [self.view removeFromSuperview];
    if(self.delegate!=nil && [self.delegate conformsToProtocol:@protocol(ICSpanlishDelegate)])
    {
        [self.delegate EndSplish:self];
    }
}


-(void)getRadomArr
{
    //frameArr
    for (int i=0; i<24; i++) {
        for (int j=0; j<1000; j++) {
            NSInteger random = arc4random()%24;
            if ([frameArr containsObject:[NSNumber numberWithInt:random]]) {
                continue;
            }else {
                [frameArr addObject:[NSNumber numberWithInt:random]];
                break;
            }
        }
    }
    NSLog(@"frameArr:%@",frameArr);
    
    [radomArr addObject:[NSNumber numberWithInt:5]];
    [radomArr addObject:[NSNumber numberWithInt:11]];
    [radomArr addObject:[NSNumber numberWithInt:17]];
    [radomArr addObject:[NSNumber numberWithInt:23]];
    
    [radomArr addObject:[NSNumber numberWithInt:4]];
    [radomArr addObject:[NSNumber numberWithInt:10]];
    [radomArr addObject:[NSNumber numberWithInt:16]];
    [radomArr addObject:[NSNumber numberWithInt:22]];
    
    [radomArr addObject:[NSNumber numberWithInt:3]];
    [radomArr addObject:[NSNumber numberWithInt:9]];
    [radomArr addObject:[NSNumber numberWithInt:15]];
    [radomArr addObject:[NSNumber numberWithInt:21]];
    
    [radomArr addObject:[NSNumber numberWithInt:2]];
    [radomArr addObject:[NSNumber numberWithInt:8]];
    [radomArr addObject:[NSNumber numberWithInt:14]];
    [radomArr addObject:[NSNumber numberWithInt:20]];
    
    [radomArr addObject:[NSNumber numberWithInt:1]];
    [radomArr addObject:[NSNumber numberWithInt:7]];
    [radomArr addObject:[NSNumber numberWithInt:13]];
    [radomArr addObject:[NSNumber numberWithInt:19]];
    
    [radomArr addObject:[NSNumber numberWithInt:0]];
    [radomArr addObject:[NSNumber numberWithInt:6]];
    [radomArr addObject:[NSNumber numberWithInt:12]];
    [radomArr addObject:[NSNumber numberWithInt:18]];
    
}
-(void)FlipView:(UIImageView *)view
{
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view cache:YES];
    [UIView setAnimationDuration:1];
    [UIView setAnimationRepeatCount:1];
    
    NSNumber *number = [frameArr objectAtIndex:view.tag-100];
    NSInteger count = [number integerValue]+1;
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d.png",count]];
    
    [UIView commitAnimations];
}

-(void)FlipViewandRemove:(UIImageView *)view
{
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view cache:YES];
    [UIView setAnimationDuration:1];
    [UIView setAnimationRepeatCount:1];
    
    view.image = [UIImage imageNamed:@""];
    
    [UIView commitAnimations];
}
-(void)RemoveView
{
    for (int i=0; i<radomArr.count; i++) {
        NSNumber *number = [radomArr objectAtIndex:i];
        UIImageView *img = (UIImageView *)[self.view viewWithTag:100+[number integerValue]];
        [self performSelector:@selector(FlipViewandRemove:) withObject:img afterDelay:i/15.0];
    }
    [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}
-(void)ShowLogo
{
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 318.5, 81)];
    logo.image = [UIImage imageNamed:@"loading_logo.png"];
    logo.center = CGPointMake(160,240);
    [self.view addSubview:logo];
    logo.alpha = 0;
    
    [UIView animateWithDuration:2 animations:^{logo.alpha = 1;} completion:^(BOOL flag)
     {
         sleep(1);
         [self performSelector:@selector(RemoveView) withObject:nil afterDelay:1.5];
         [UIView animateWithDuration:2 animations:^{logo.alpha = 0;} completion:^(BOOL flag)
          {
              
          }];
     }];
    
    [logo release];
    
}


@end
