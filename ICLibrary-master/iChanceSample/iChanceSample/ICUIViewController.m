//
//  ICUIViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICUIViewController.h"
#import "ICZoomableImageViewDemo.h"
#import "ICLabelDemo.h"
#import "ICCalendarViewDemo.h"
#import "ICPullTableViewController.h"

@interface ICUIViewController ()

@end

@implementation ICUIViewController

#pragma mark - Memory manager
-(void)dealloc
{
    [_tableView release];
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidUnload
{
    _tableView = nil;
    [super viewDidUnload];
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
	
    //navigation title
    self.navigationItem.title = @"UI";
    
    //init data source
    _dataSource = [[NSArray alloc] initWithObjects:@"ICZoomableImageView",@"ICLabel",@"ICCalendar",
                   @"PullTable",nil];
    
    
    //add table
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer=@"CellIndentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell==nil){
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer]autorelease];
    }
    
    if (indexPath.row < [_dataSource count]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataSource objectAtIndex:indexPath.row]];    
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //ICZoomableImageView
        ICZoomableImageViewDemo *zoomableImageViewDemo = [[ICZoomableImageViewDemo alloc] init];
        [self.navigationController pushViewController:zoomableImageViewDemo animated:YES];
        [zoomableImageViewDemo release];
    }
    
    if (indexPath.row == 1) {
        //ICLabel
        ICLabelDemo *icLabelDemo = [[ICLabelDemo alloc] init];
        [self.navigationController pushViewController:icLabelDemo animated:YES];
        [icLabelDemo release];
    }
    
    if (indexPath.row == 2) {
        //ICCalendar
        ICCalendarViewDemo *calendarViewDemo = [[ICCalendarViewDemo alloc] init];
        [self.navigationController pushViewController:calendarViewDemo animated:YES];
        [calendarViewDemo release];
    }
    
    if (indexPath.row == 3) {
        //PullTable
        ICPullTableViewController *pullTable = [[ICPullTableViewController alloc] init];
        [self.navigationController pushViewController:pullTable animated:YES];
        [pullTable release];
    }
}


@end
