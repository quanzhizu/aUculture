//
//  UIImageView+ICCategory.m
//  WhiteBook2
//
//  Created by Fox on 13-2-25.
//  Copyright (c) 2013年 c1618. All rights reserved.
//

#import "UIImageView+ICCategory.h"

@implementation UIImageView (ICCategory)

- (void)setImageWithURL:(NSURL *)url inRect:(CGRect )rect
{
    //根据rect来进行调整
    
    [[SDWebImageManager sharedManager] downloadWithURL:url delegate:self options:SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
        //调整contentsize

        //图片实际的宽度和高度
        float image_width = image.size.width;
        float image_height = image.size.height;
        
        float frame_x = rect.origin.x;
        float frame_y = rect.origin.y;
        float frame_width = rect.size.width;
        float frame_height = rect.size.height;

        float adaptive_width = frame_width;
        float adaptive_height = frame_height;
        
        if (image_height / image_width >= frame_height / frame_width) {
            //高度固定，宽度自适应
            adaptive_height = frame_height;
            adaptive_width = image_width / image_height *frame_height;
        }else{
            //宽度固定，高度自适应
            adaptive_width = frame_width;
            adaptive_height = image_height / image_width * frame_width;
        }
        
        [self setFrame:CGRectMake(frame_x, frame_y, adaptive_width, adaptive_height)];
        
//        NSLog(@"%f %f %f %f",frame_x,frame_y,adaptive_width,adaptive_height);
        
    } failure:^(NSError *error) {
        [self setFrame:rect];
    }];
    
    
}

@end
