//
//  CUSTableLayoutSampleViewController.m
//  CUSLayout
//
//  Created by zhangyu on 13-4-16.
//  Copyright (c) 2013年 zhangyu. All rights reserved.
//

#import "CUSTableLayoutSampleViewController.h"
@implementation CUSTableLayoutSampleViewController{
    NSMutableArray *colums;
    NSMutableArray *rows;
}
@synthesize contentView;
@synthesize scrollView;

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(320 * 2, 44);
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSInteger controlCounter = 13;
    for (int i = 0; i < controlCounter; i++) {
        UIView *button = [CUSLayoutSampleFactory createControl:[NSString stringWithFormat:@"button%i",i]];
        [self.contentView addSubview:button];
    }
    
//    NSMutableArray *colums = [NSMutableArray array];
//    [colums addObject:[CUSValue valueWithPercent:0.10]];
//    [colums addObject:[CUSValue valueWithFloat:50]];
//    [colums addObject:[CUSValue valueWithPercent:0.20]];
//    [colums addObject:[CUSValue valueWithDefault]];
//    
//    NSMutableArray *rows = [NSMutableArray array];
//    [rows addObject:[CUSValue valueWithFloat:100]];
//    [rows addObject:[CUSValue valueWithDefault]];
//    [rows addObject:[CUSValue valueWithPercent:0.30]];
//    [rows addObject:[CUSValue valueWithPercent:0.20]];
    
    colums = [NSMutableArray array];
    for (int i = 0 ; i < 4; i++) {
        [colums addObject:[CUSValue valueWithPercent:0.25]];
    }
    rows = [NSMutableArray array];
    for (int i = 0 ; i < 4; i++) {
        [rows addObject:[CUSValue valueWithPercent:0.25]];
    }
    
    CUSTableLayout *layout = [[CUSTableLayout alloc]initWithcolumns:colums rows:rows];
    //合并单元格演示
    [layout merge:1 row:1 colspan:2 rowspan:2];
    self.contentView.layoutFrame = layout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toolItemClicked:(id)sender{
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    CUSTableLayout *layout = (CUSTableLayout *)self.contentView.layoutFrame;
    if(btn.tag == 1){
        layout.spacing -= 5;
        if(layout.spacing < 0){
            layout.spacing = 0;
        }
    }else if(btn.tag == 2){
        layout.spacing += 5;
    }else if(btn.tag == 3){
        if([colums count] > 0){
            [colums removeLastObject];
            self.contentView.layoutFrame = [self createNewTableLayoutByOld:layout];
        }
    }else if(btn.tag == 4){
        [colums addObject:[CUSValue valueWithPercent:0.25]];
        self.contentView.layoutFrame = [self createNewTableLayoutByOld:layout];
    }else if(btn.tag == 5){
        if([rows count] > 0){
            [rows removeLastObject];
            self.contentView.layoutFrame = [self createNewTableLayoutByOld:layout];
        }
    }else if(btn.tag == 6){
        [rows addObject:[CUSValue valueWithPercent:0.25]];
        self.contentView.layoutFrame = [self createNewTableLayoutByOld:layout];
    }else if(btn.tag == 10){
        NSArray *array = self.contentView.subviews;
        if(array && [array count] > 0){
            UIView *lastView = [array lastObject];
            [lastView removeFromSuperview];
        }
    }else if(btn.tag == 11){
        UIView *view = [CUSLayoutSampleFactory createControl:[NSString stringWithFormat:@"button%i",[self.contentView.subviews count]]];
        [self.contentView addSubview:view];
    }
    
    [self.contentView CUSLayout:YES];
}

-(CUSTableLayout *)createNewTableLayoutByOld:(CUSTableLayout *)oldLayout{
    CUSTableLayout *newLayout = [[CUSTableLayout alloc]initWithcolumns:colums rows:rows];
    newLayout.spacing = oldLayout.spacing;
    return newLayout;
}

@end
