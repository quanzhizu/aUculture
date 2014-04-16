//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"
#import "SDImageView+SDWebCache.h"
@implementation CycleScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray picTitle:(NSArray *)pictitleArray{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        titleArray = [[NSArray alloc] initWithArray:pictitleArray];
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollFrame.size.height - 25, scrollFrame.size.width, 25)];
        bottomView.backgroundColor = [UIColor clearColor];
        
        UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, 25)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.4;
        [bottomView addSubview:blackView];
        [blackView release];
        
        pictitle = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 250, 25)];
        pictitle.backgroundColor = [UIColor clearColor];
        
        pictitle.textColor = [UIColor whiteColor];
        if (pictitleArray.count>0) {
             pictitle.text = [titleArray objectAtIndex:0];
        }
        
        pictitle.font = [UIFont systemFontOfSize:13.0f];
        [bottomView addSubview:pictitle];
        [pictitle release];
                
        
        if (pictureArray.count == 1) {
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:scrollFrame]autorelease];
            imageView.userInteractionEnabled = YES;
            //设置图片已连接的形式
            
            [imageView setImageWithURL:[NSURL URLWithString:[pictitleArray objectAtIndex:0]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"meili.jpg"]];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];
            [scrollView addSubview:imageView];

        }else{
            
            for (int i =0;i<pictureArray.count;i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(300-i*12, 8.5, 8, 8);
                btn.tag = 100+pictureArray.count-i-1;
                if (i == pictureArray.count - 1) {
                    btn.selected = YES;
                }
                btn.userInteractionEnabled = NO;
                [btn setBackgroundImage:[UIImage imageNamed:@"pagenum.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"pagenum_select.png"] forState:UIControlStateSelected];
                [bottomView addSubview:btn];
            }
            // 在水平方向滚动
            if(scrollDirection == CycleDirectionLandscape) {
                scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                    scrollView.frame.size.height);
            }
            // 在垂直方向滚动
            if(scrollDirection == CycleDirectionPortait) {
                scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                    scrollView.frame.size.height * 3);
            }
            [self refreshScrollView];
        }
        
        [self addSubview:scrollView];
        
        [self addSubview:bottomView];
        [bottomView release];
        
    }
    
    return self;
}

- (void)refreshScrollView {
    
    if (imagesArray.count>0) {
        NSArray *subViews = [scrollView subviews];
        if([subViews count] != 0) {
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [self getDisplayImagesWithCurpage:curPage];
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:scrollFrame]autorelease];
            imageView.userInteractionEnabled = YES;
            //设置图片已连接的形式
 
            
            if (scrollFrame.size.height >160) {
                 [imageView setImageWithURL:[NSURL URLWithString:[curImages objectAtIndex:i]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholder0.png"]];
            }else{
                [imageView setImageWithURL:[NSURL URLWithString:[curImages objectAtIndex:i]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholder9.png"]];
            }
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];
            
            // 水平滚动
            if(scrollDirection == CycleDirectionLandscape) {
                imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
            }
            // 垂直滚动
            if(scrollDirection == CycleDirectionPortait) {
                imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
            }
            
            
            [scrollView addSubview:imageView];
        }
        if (scrollDirection == CycleDirectionLandscape) {
            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
        }
        if (scrollDirection == CycleDirectionPortait) {
            [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
        }
    }
    
    
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

-(void)zidong
{
    int flag = curPage;
    if (flag == imagesArray.count) {
        flag = 0;
    }
    
    for (int i = 0;i<imagesArray.count;i++) {
        UIButton *btn  = (UIButton *)[self viewWithTag:100+i];
        if (i == flag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if (titleArray.count>flag) {
         pictitle.text = [titleArray objectAtIndex:flag];
    }
    
    scrollView.pagingEnabled = YES;
    [scrollView setContentOffset:CGPointMake(640, 0)animated:YES];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    int flag = curPage-1;
    if(titleArray.count>flag){
        pictitle.text = [titleArray objectAtIndex:flag];
    }
    
    for (int i = 0;i<imagesArray.count;i++) {
        UIButton *btn  = (UIButton *)[self viewWithTag:100+i];
        if (i == flag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if (scrollDirection == CycleDirectionLandscape) {
            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{ 
    if ([delegate respondsToSelector:@selector(cycleScrollViewWillBeginDraing)]) {
        [delegate cycleScrollViewWillBeginDraing];
    }}
- (void)dealloc
{
    [imagesArray release];
    [curImages release];
    
    [super dealloc];
}

@end
