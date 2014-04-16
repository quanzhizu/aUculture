//
//  ICTableView.h
//  iChanceSample
//
//  Created by Fox on 13-3-2.
//
//

/*
 ICTableView处理如下问题：
 1、表格的上下拉动刷新；（上拉、下提都有，也可以单独设置为无）
 2、数据源处理；（处理数据的分页和缓存，数据请求单独分开）
 */


#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@class ICTableView;

@protocol ICTableViewDelegate <NSObject>

@required
- (UITableViewCell *)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
                      withData:(NSDictionary *)data;

@optional
- (void) didSelectRow:(UITableView *)tableView
                 cell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
       dataDictionary:(NSDictionary *)dataDictionary;

@end

@interface ICTableView : UIView <UITableViewDelegate,UITableViewDataSource,
PullingRefreshTableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) PullingRefreshTableView *pullTableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) id<ICTableViewDelegate> delegate;

//缓存，需要将设置缓存开启，并且设置缓存名称
@property (nonatomic, assign) BOOL isNeedCache;
@property (nonatomic, copy) NSString *cacheName;

//设置项目 (默认头尾都需要，可根据设定来处理)
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) BOOL isRowHeightVariable;

//init
- (void)loadData;//该方法放在最后，在将要被添加到superView之前调用

//update
- (void)updateAllSucess:(NSArray *)data;

@end
