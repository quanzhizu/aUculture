//
//  ICTabBarController.m
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICTabBarController.h"


@implementation ICTabBarItem
@synthesize CustomHighlightedImage;

-(void)dealloc{
	[super dealloc];
	CustomHighlightedImage=nil;
	[CustomHighlightedImage release];
}

-(UIImage *)selectedImage{
	return self.CustomHighlightedImage;
}

@end



@interface ICTabBarController ()

@end

@implementation ICTabBarController
@synthesize TabbarBackgroundImage;

#pragma mark - Memory manager
-(void)dealloc
{
    [TabbarBackgroundImage release];
    [super dealloc];
}

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
	
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48); 
	
	UIImageView *imgView=[[UIImageView alloc] initWithFrame:frame];
	imgView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	[imgView setImage:self.TabbarBackgroundImage];
    
    [self.tabBar insertSubview:imgView atIndex:0];
	[imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
