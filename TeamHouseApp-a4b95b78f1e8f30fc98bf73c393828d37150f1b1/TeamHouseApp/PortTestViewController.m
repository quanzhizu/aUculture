//
//  PortTestViewController.m
//  TeamHouseApp
//
//  Created by 刘法亮 on 13-12-31.
//  Copyright (c) 2013年 liu faliang. All rights reserved.
//

#import "PortTestViewController.h"
#import "LoadViewController.h"
#import "ChangePswViewController.h"
#import "UserInfoViewController.h"
#import "PosionInfoViewController.h"
#import "HouseSourceViewController.h"
#import "HouseRentViewController.h"
#import "HouseSellViewController.h"
#import "CommenDataView.h"
@interface PortTestViewController ()
{
    NSArray *portArr;
}
@end

@implementation PortTestViewController

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
    NSLog(@"asdfasdfasf");
    portArr = [[NSArray alloc]initWithObjects:@"用户登录",@"修改密码",@"位置定位",@"信息推送",@"房源首页",@"出租房屋",@"出售房屋",@"自定义数据", nil];
    [myTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return portArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [portArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int d = indexPath.row;
    if (d == 0) {
        LoadViewController *loadView = [[LoadViewController alloc]initWithNibName:@"LoadViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];
    }else if (d == 1){
        ChangePswViewController *loadView = [[ChangePswViewController alloc]initWithNibName:@"ChangePswViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];

    }else if (d == 2){
        PosionInfoViewController *loadView = [[PosionInfoViewController alloc]initWithNibName:@"PosionInfoViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];
    }else if (d == 3){
        
    }else if (d == 4){
        HouseSourceViewController *loadView = [[HouseSourceViewController alloc]initWithNibName:@"HouseSourceViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];

    }else if (d == 5){
        HouseRentViewController *loadView = [[HouseRentViewController alloc]initWithNibName:@"HouseRentViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];

    }else if (d == 6){
        HouseSellViewController *loadView = [[HouseSellViewController alloc]initWithNibName:@"HouseSellViewController" bundle:nil];
        [self.navigationController pushViewController:loadView animated:YES];
        
    }else if (d == 7){
        CommenDataView *loadView = [[CommenDataView alloc]init];
        [self.navigationController pushViewController:loadView animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
