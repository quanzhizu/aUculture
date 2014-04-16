//
//  AnimationDemo.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnimationDemo.h"

@interface AnimationDemo ()

- (void)showAnimation:(id)sender;

@end

@implementation AnimationDemo

#pragma mark - Memory mamger
-(void)dealloc
{
    [_animationImage release];
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
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //title
    self.navigationItem.title = @"Animation Demo";
    
    //animation image
    _animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 30, 180, 240)];
    [_animationImage setImage:[UIImage imageNamed:@"test.jpg"]];
    [self.view addSubview:_animationImage];
    
    
    //button
    for (int i = 0; i < 7 ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[NSString stringWithFormat:@"Anima:%d",i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(60 + 75 * (i %3), 280 + 40 * (i / 3), 60, 30)];
        [button addTarget:self 
                   action:@selector(showAnimation:) 
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
    }
    
    
}

- (void)showAnimation:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 0:{
        
            if (_animationImage.hidden) {
                [_animationImage backInFrom:kFTAnimationTop 
                                     inView:_animationImage.superview
                                   withFade:NO 
                                   duration:0.4 
                                   delegate:nil 
                              startSelector:nil 
                               stopSelector:nil];
            }else {
                [_animationImage  backOutTo:kFTAnimationTop 
                                     inView:_animationImage.superview
                                   withFade:NO 
                                   duration:0.4 
                                   delegate:nil 
                              startSelector:nil 
                               stopSelector:nil];                
            }
            
        }
            break;
        case 1:{
            if (_animationImage.hidden) {
                [_animationImage slideInFrom:kFTAnimationTop 
                                      inView:_animationImage.superview 
                                    duration:0.4 
                                    delegate:nil 
                               startSelector:nil 
                                stopSelector:nil];
            }else {

                [_animationImage slideOutTo:kFTAnimationTop 
                                     inView:_animationImage.superview 
                                   duration:0.4 
                                   delegate:nil 
                              startSelector:nil 
                               stopSelector:nil];
            }
        }
            break;
        case 2:{
            if (_animationImage.hidden) {
                [_animationImage fadeIn:0.4 delegate:nil];
            }else {
                [_animationImage fadeOut:0.4 delegate:nil];
            }
        }
            break;
        case 3:{
            if(_animationImage.hidden) {
                [_animationImage fadeBackgroundColorIn:.4 delegate:nil];
            } else {
                [_animationImage fadeBackgroundColorOut:.4 delegate:nil];
            }
        }
            break;
        case 4:{
            if(_animationImage.hidden) {
                [_animationImage popIn:.4 delegate:nil];
            } else {
                [_animationImage popOut:.4 delegate:nil];
            }
        }
            break;
        case 5:{
            if(_animationImage.hidden) {
                [_animationImage fallIn:.4 delegate:nil];
            } else {
                [_animationImage fallOut:.4 delegate:nil];
            }
        }
            break;
        case 6:{
            if(_animationImage.hidden) {
                [_animationImage fadeIn:.2 delegate:nil];
            } else {
                [_animationImage flyOut:.4 delegate:nil];
            }
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
