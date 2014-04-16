//
//  DefaultGoodsView.h
//  Qinzijie
//
//  Created by zhizuquan on 14-4-11.
//  Copyright (c) 2014年 iconverge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleGoodSView : UIView

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UIImageView *titileImageView;
@property (nonatomic, strong) NSLayoutConstraint *nameLable_height;
@end


@interface DefaultGoodsView : UIImageView

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *titileImageView;
@end
