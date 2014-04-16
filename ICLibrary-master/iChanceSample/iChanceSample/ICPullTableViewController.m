//
//  ICPullTableViewController.m
//  iChanceSample
//
//  Created by Fox on 13-3-2.
//
//

#import "ICPullTableViewController.h"

@interface ICPullTableViewController ()
{
    NSMutableArray *dataSourse;
}
@end

@implementation ICPullTableViewController

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
	// Do any additional setup after loading the view.
    
    dataSourse = [[NSMutableArray alloc] initWithCapacity:0];
    [dataSourse addObject:@"121212"];
    [dataSourse addObject:@"343434"];
    [dataSourse addObject:@"3434eer"];
    [dataSourse addObject:@"ererdfd"];
    [dataSourse addObject:@"cvvfghfgh"];
    [dataSourse addObject:@"hgghtyty"];
    [dataSourse addObject:@"ghghgh"];
    [dataSourse addObject:@"hghghhgh"];
    [dataSourse addObject:@"ghghtyt"];
    [dataSourse addObject:@"rtrtrttr"];
    
    
    
    PullingRefreshTableView *_tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.bounds pullingDelegate:self];
    [self.view addSubview:_tableView];
    _tableView.autoScrollToNextPage = YES;
    _tableView.headerOnly = NO;
    _tableView.needHeader = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView release];
    

    

    
    [_tableView launchRefreshing];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PullingRefreshTableViewDelegate methods
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //上拉刷新
    [dataSourse removeAllObjects];
    [dataSourse addObject:@"121212"];
    [dataSourse addObject:@"343434"];
    [dataSourse addObject:@"3434eer"];
    [dataSourse addObject:@"ererdfd"];
    [dataSourse addObject:@"cvvfghfgh"];
    [dataSourse addObject:@"hgghtyty"];
    [dataSourse addObject:@"ghghgh"];
    [dataSourse addObject:@"hghghhgh"];
    [dataSourse addObject:@"ghghtyt"];
    [dataSourse addObject:@"rtrtrttr"];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //加载更多
    [dataSourse addObject:@"121212"];
    [dataSourse addObject:@"343434"];
    [dataSourse addObject:@"3434eer"];
    [dataSourse addObject:@"ererdfd"];
    [dataSourse addObject:@"cvvfghfgh"];
    [dataSourse addObject:@"hgghtyty"];
    [dataSourse addObject:@"ghghgh"];
    [dataSourse addObject:@"hghghhgh"];
    [dataSourse addObject:@"ghghtyt"];
    [dataSourse addObject:@"rtrtrttr"];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSourse count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dataSourse objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
