//
//  ICAnimationViewController.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICAnimationViewController.h"
#import "AnimationDemo.h"
#import "ICSpanlishViewController.h"

@interface ICAnimationViewController ()

@end

@implementation ICAnimationViewController

#pragma mark - Memory manager
-(void)dealloc
{
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UIViewController  life cycle
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
	
    //title
    self.navigationItem.title = @"ICAnimation";
    
    //datesource
    [_dataSource addObject:@"FTAnimation"];
    [_dataSource addObject:@"ICSpanlishView"];
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
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
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
        //animation
        AnimationDemo *animationDemo = [[AnimationDemo alloc] init];
        [self.navigationController pushViewController:animationDemo animated:YES];
        [animationDemo release];
    }
    
    if (indexPath.row == 1) {
        //ICSpanlishViewCOntroller
        ICSpanlishViewController *spanlishViewController = [[ICSpanlishViewController alloc] init];
        [self.navigationController pushViewController:spanlishViewController animated:YES];
        [spanlishViewController release];
    }
    
}


@end
