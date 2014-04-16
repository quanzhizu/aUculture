//
//  FirstViewController.m
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import "FirstViewController.h"
#import "GoodsCell.h"
#import "UIImageView+WebCache.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize mytableView,numberArray,refreshing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mytableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 110) pullingDelegate:self];
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    self.mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //    [self.tableView setHeaderOnly:YES];          //只有上拉刷新
    //    [self.tableView setFooterOnly:YES];          //只有下拉刷新
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mytableView];
    
    [self.mytableView launchRefreshing];
    numberArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
}


#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
//    for (int i=0; i<5; i++) {
//        [numberArray addObject:@"placeholder"];
//    }
    [self.mytableView tableViewDidFinishedLoading];
    self.mytableView.reachedTheEnd  = NO;
    [self.mytableView reloadData];
}

//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadImagesForOnscreenRows{
    
    NSArray *visiblePaths = [self.mytableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
       UITableViewCell *cell = [self.mytableView cellForRowAtIndexPath:indexPath];
//        if (self.mytableView ) {
//            <#statements#>
//        }
    }
    
}
#pragma mark -
#pragma mark - ScrollView Method
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.mytableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mytableView tableViewDidEndDragging:scrollView];
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [numberArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *str = [numberArray objectAtIndex:indexPath.row];
    GoodsCell *cell;
    if ([str isEqualToString:@"1"]) {
        cell= (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:DTYPE_SCTROLL];
        if (cell == nil) {
            
            cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DTYPE_SCTROLL];
            
        }
        if (self.mytableView.dragging == NO && self.mytableView.decelerating == NO) {
            int i = 0;
            for (UIImageView *imageView in cell.mainScorllView.allContentViews) {
                switch (i) {
                    case 0:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://pic22.nipic.com/20120731/8813830_111320075356_2.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    case 1:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://www.aiimg.com/uploads/userup/1202/2G305563208.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    case 2:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://pic22.nipic.com/20120803/8931843_103057963000_2.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    case 3:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://pic22.nipic.com/20120713/8931843_094520377000_2.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    case 4:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://img10.dayoo.com/3g/attachement/jpg/site1/20120409/001372af6dc310ec859456.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    case 5:
                        [imageView setImageWithURL:[NSURL URLWithString:@"http://pic10.nipic.com/20100928/5843711_090157063259_2.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                        break;
                    default:
                        break;
                }
                i++;
                NSLog(@"i == %d cell.mainScorllView.contentViews COUNT = %d\n",i,[cell.mainScorllView.contentViews count]);
            }
        }
        
    }else if ([str isEqualToString:@"2"] || [str isEqualToString:@"3"]){
        cell= (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:DTYPE_TWO];
        if (cell == nil) {
            
            cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DTYPE_TWO];
        }
        
        cell.leftGoodsView.activityLable.text = @"特价";
        cell.rightGoodsView.activityLable.text = @"特价";
        if (self.mytableView.dragging == NO && self.mytableView.decelerating == NO) {
            if ([str isEqualToString:@"2"]){
                cell.leftGoodsView.priceLable.text = @"1999";
                cell.rightGoodsView.priceLable.text = @"2999";
                [cell.leftGoodsView.goodsImageView setImageWithURL:[NSURL URLWithString:@"http://wilsoncomm.com.hk/userfiles/userupload/DSC01901.JPG"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                [cell.rightGoodsView.goodsImageView setImageWithURL:[NSURL URLWithString:@"http://product.hiapk.com/images/201209/thumb_img/75_thumb_G_1348820635336.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            }
            if ([str isEqualToString:@"3"]){
                cell.leftGoodsView.priceLable.text = @"2777";
                cell.rightGoodsView.priceLable.text = @"3120";
                [cell.leftGoodsView.goodsImageView setImageWithURL:[NSURL URLWithString:@"http://pimages3.tianjimedia.com/resources/product/20130515/2KR2584TC97LJ9293GG63GDX69UI0XC4.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
                [cell.rightGoodsView.goodsImageView setImageWithURL:[NSURL URLWithString:@"http://pic8.nipic.com/20100730/900677_163450097994_2.jpg"] placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            }
           
        }
    }else if ([str isEqualToString:@"4"] || [str isEqualToString:@"5"]){
        cell= (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:DTYPE_DEFAULT];
        if (cell == nil) {
            
            cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DTYPE_DEFAULT];
        }
    }
    
    
    //Configure the cell ...
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //NSLog(@"numberArray == %@",[numberArray objectAtIndex:indexPath.row]);
   // cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

//This is not necessday
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
