//
//  UIImage+ICCategory.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ICCategory)

- (UIImage *)subImageAtRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor   
                           shadeAlpha1:(CGFloat)alpha1   
                           shadeAlpha2:(CGFloat)alpha2  
                           shadeAlpha3:(CGFloat)alpha3   
                           shadowColor:(UIColor *)shadowColor   
                          shadowOffset:(CGSize)shadowOffset   
                            shadowBlur:(CGFloat)shadowBlur;

@end
