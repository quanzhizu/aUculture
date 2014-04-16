//
//  ICTableViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICTableViewController.h"

@interface ICTableViewController ()

@end

@implementation ICTableViewController

#pragma mark - Memory manager
-(void)dealloc
{
    [_pullingRefreshTableView release];
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidUnload
{
    _pullingRefreshTableView = nil;
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
    
    //init data source
    _dataSource = [[NSMutableArray alloc] init];
    
    //add table
    _pullingRefreshTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) pullingDelegate:self];
    _pullingRefreshTableView.autoScrollToNextPage = NO;
    _pullingRefreshTableView.needHeader = YES;
    _pullingRefreshTableView.delegate = self;
    _pullingRefreshTableView.dataSource = self;
    [self.view addSubview:_pullingRefreshTableView];

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
    
   
    return cell;
}



#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - PullingRefreshTableViewDelegate methods
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //下拉更新（头部拉动更新）
    NSLog(@"pullingTableViewDidStartRefreshing");

    [UIView animateWithDuration:5 animations:^(){
    
    } completion:^(BOOL finish){
        [_pullingRefreshTableView tableViewDidFinishedLoading];
        NSLog(@"tableViewDidFinishedLoading");
    }];
    
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //上拉更新，拉动尾部更新
    //Implement this method if headerOnly is false
    NSLog(@"pullingTableViewDidStartLoading");
    
    [UIView animateWithDuration:5 animations:^(){
        
    } completion:^(BOOL finish){
        [_pullingRefreshTableView tableViewDidFinishedLoading];
        NSLog(@"tableViewDidFinishedLoading");
    }];
}

#pragma mark - UISCrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pullingRefreshTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pullingRefreshTableView tableViewDidEndDragging:scrollView];
}


@end
