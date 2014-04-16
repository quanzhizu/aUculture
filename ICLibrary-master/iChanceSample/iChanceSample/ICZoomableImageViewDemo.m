//
//  ICZoomableImageViewDemo.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICZoomableImageViewDemo.h"

@interface ICZoomableImageViewDemo ()

@end

@implementation ICZoomableImageViewDemo

#pragma mark - Memory manger
-(void)dealloc
{
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UIViewcontroller life cycle
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
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"zoomableImageView";
    
    ICZoomableImageView *zoomableImageView = [[ICZoomableImageView alloc] initwithImage:[UIImage imageNamed:@"test.jpg"] frame:self.view.bounds];
    zoomableImageView.zoomableImageDelegate = self;
    [self.view addSubview:zoomableImageView];
    [zoomableImageView release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ICZoomableImageViewDelegate methods
- (void) zoomableImageViewonSingleTap:(ICZoomableImageView *)zoomableImageView singleTap:(UIGestureRecognizer *) gesture
{
    NSLog(@"singletap");
}


- (void) zoomableImageViewonDoubleTap:(ICZoomableImageView *)zoomableImageView doubleTap:(UIGestureRecognizer *) gesture
{
    NSLog(@"doubletap");
}


@end
