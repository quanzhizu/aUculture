//
//  ICTableView.m
//  iChanceSample
//
//  Created by Fox on 13-3-2.
//
//

#import "ICTableView.h"
#import "UIColor+ICCategory.h"

#define NORESULTSTRING      @"暂无数据"
#define CELLHEIGHT          50

@interface ICTableView ()

//update
- (void)refreshAll;
- (void)refreshFinish;
- (void)reloadTableData;
@end



@implementation ICTableView
@synthesize pullTableView;
@synthesize dataSource;
@synthesize currentPage;
@synthesize isNeedCache;
@synthesize cacheName;
@synthesize isNeedHeader;
@synthesize isNeedFooter;
@synthesize delegate;
@synthesize cellHeight;
@synthesize isRowHeightVariable;

#pragma mark - Memory manager
-(void)dealloc
{
    self.dataSource = nil;
    self.pullTableView = nil;
    [super dealloc];
}

#pragma mark - Init
-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //数据初始化
    self.dataSource = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    self.currentPage = 1;
    self.isNeedCache = NO;      //默认不缓存
    self.isNeedHeader = YES;    //默认需要头
    self.isNeedFooter = YES;    //默认需要尾
    self.cellHeight = CELLHEIGHT;
    self.isRowHeightVariable = NO;  //默认cell高度不变
}

- (void)loadData
{
    //试图将要被加载到superView时调用
    self.pullTableView = [[[PullingRefreshTableView alloc] initWithFrame:self.bounds
                                                     pullingDelegate:self] autorelease];
    self.pullTableView.headerOnly = !self.isNeedFooter;
    self.pullTableView.needHeader = self.isNeedHeader;
    self.pullTableView.dataSource = self;
    self.pullTableView.delegate = self;
    [self.pullTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.pullTableView];
    
    //读取数据
    if (self.isNeedCache && self.cacheName.length != 0) {
        //读取缓存数据
    }else{
        //每次初始化刷新数据
        [self refreshAll];
    }
    
}


#pragma mark - Update 
- (void)refreshAll
{
    //刷新全部
    [self.pullTableView launchRefreshing];
}

- (void)refreshFinish
{
    //刷新完成
    [self.pullTableView tableViewDidFinishedLoading];
    [self reloadTableData];
}

- (void)reloadTableData
{
    //在加载下一页的时候，表格reload后需要再次移动到之前的位置
    CGPoint oldContentOffset = self.pullTableView.contentOffset;
    [self.pullTableView reloadData];
    self.pullTableView.contentOffset = oldContentOffset;
}


#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isRowHeightVariable){
        //高度变化
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    
    //默认高度
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中某一项
    int rowNumber = indexPath.row;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectRow:cell:atIndexPath:dataDictionary:)]) {
        [self.delegate didSelectRow:tableView
                               cell:[tableView cellForRowAtIndexPath:indexPath]
                        atIndexPath:indexPath
                     dataDictionary:[self.dataSource objectAtIndex:rowNumber]];
    }
}



#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource count] == 0) {
        //没有数据时，提供一行进行提示
        return 1;
    }else{
        return [self.dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.dataSource.count == 0) {
        //没有数据时，提供一行进行提示
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"noResult"];
        if(cell==nil){
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"noResult"] autorelease];
            UILabel *noResultsLabel=[[UILabel alloc] initWithFrame:
                                     CGRectMake(0,0,self.pullTableView.frame.size.width,cell.frame.size.height)];
            noResultsLabel.text = NORESULTSTRING;
            noResultsLabel.backgroundColor=[UIColor clearColor];
            noResultsLabel.textColor= [UIColor colorForHex:@"bfbfbf"];
            noResultsLabel.textAlignment=UITextAlignmentCenter;
            [cell addSubview:noResultsLabel];
            [noResultsLabel release];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            self.pullTableView.headerOnly=YES;
        }
        return cell;
    }
    
    //有数据时
    UITableViewCell *tableViewCell = [self.delegate tableView:tableView
                                                  atIndexPath:indexPath
                                                     withData:[dataSource objectAtIndex:indexPath.row]];
    
    return tableViewCell;
    
}

#pragma mark - PullingRefreshTableViewDelegate methods
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //上拉刷新
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //下拉加载更懂
}



@end
