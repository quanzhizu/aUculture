//
//  ICCalendarViewDemo.m
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICCalendarViewDemo.h"
#import "ICCalendarView.h"


@interface ICCalendarViewDemo ()

@end

@implementation ICCalendarViewDemo

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
    
    ICCalendarView *calendar = [[ICCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    [calendar release];
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

#pragma mark - ICCalendarViewDelegate
-(void)calendarView:(ICCalendarView *)calendarView 
    switchedToMonth:(int)month 
       targetHeight:(float)targetHeight 
           animated:(BOOL)animated
{
    if (month==[[NSDate date] month]) {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
}

-(void)calendarView:(ICCalendarView *)calendarView dateSelected:(NSDate *)date
{
     NSLog(@"Selected date = %@",date);
}




@end
