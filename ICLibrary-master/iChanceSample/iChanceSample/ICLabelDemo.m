//
//  ICLabelDemo.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICLabelDemo.h"
#import "ICLabel.h"

@interface ICLabelDemo ()

@end

@implementation ICLabelDemo

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

#pragma mark - ICViewcontroller life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"ICLabel";
    
    
     ICLabel *icLabel = [[ICLabel alloc] initWithFrame:CGRectMake(20, 60, 280, 200)];
     [icLabel setFont:[UIFont fontWithName:@"Arial" size:24]];
     [icLabel setBackgroundColor:[UIColor clearColor]];
     icLabel.lineBreakMode = UILineBreakModeCharacterWrap;
     icLabel.textColor = [UIColor colorWithRed:159.0/255.5 green:159.0/255.0 blue:160.0/255.0 alpha:1.0];
     [icLabel setVerticalAlignment:VerticalAlignmentTop];
     icLabel.numberOfLines = 4;
     icLabel.text = @"ICLibrary is readlly an good ios library, it include a variety of commonly used controls.";
     [self.view addSubview:icLabel];
    [icLabel release];
     

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
