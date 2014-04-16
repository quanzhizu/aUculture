//
//  HomeViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "ICUIViewController.h"
#import "SVProgressHUD.h"
#import "ICNetworkViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - Memory mamager
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
	
    //navigation title
    self.navigationItem.title = @"ICLibrary";
    
    //init data source
    _dataSource = [[NSArray alloc] initWithObjects:@"Network",@"UI",@"Animation",@"Category", nil];
    
    
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
        //ICNetworkViewController
        ICNetworkViewController *networkViewController = [[ICNetworkViewController alloc] init];
        [self.navigationController pushViewController:networkViewController animated:YES];
        [networkViewController release];
    }
    
    
    if (indexPath.row == 1) {
        //UI
        ICUIViewController *uiViewController = [[ICUIViewController alloc] init];
        [self.navigationController pushViewController:uiViewController animated:YES];
        [uiViewController release];
    }
    
    if (indexPath.row == 2) {
        //Animation
//        ICAnimationViewController *animationViewController = [[ICAnimationViewController alloc] init];
//        [self.navigationController pushViewController:animationViewController animated:YES];
//        [animationViewController release];
        
    }
    
}




@end
