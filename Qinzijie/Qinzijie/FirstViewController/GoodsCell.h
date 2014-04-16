//
//  GoodsCell.h
//  Qinzijie
//
//  Created by zhizuquan on 14-4-10.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
#import "TwoGoodsView.h"
typedef enum {
    TYPE_DEFAULT=0,
    TYPE_TWO,
    TYPE_SCTROLL
}GOODSCELLTYPE;
#define DTYPE_DEFAULT @"defaultIdentify"
#define DTYPE_TWO @"twoIndentify"
#define DTYPE_SCTROLL @"scrollIdentify"


@interface GoodsCell : UITableViewCell
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@property (nonatomic , strong) TwoGoodsView *leftGoodsView;
@property (nonatomic , strong) TwoGoodsView *rightGoodsView;
@end
