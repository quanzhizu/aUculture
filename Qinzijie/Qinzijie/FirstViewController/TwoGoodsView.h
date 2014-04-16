//
//  TwoGoodsView.h
//  Qinzijie
//
//  Created by zhizuquan on 14-4-11.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TwoGoodsView;
typedef void (^GoodsCellBtnTouch)(TwoGoodsView * cell);

@interface TwoGoodsView : UIImageView

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) NSString *goodsImageViewUrl;
@property (nonatomic, strong) UIImageView *priceImageView;
@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *activityLable;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) GoodsCellBtnTouch btnPress;
@end
