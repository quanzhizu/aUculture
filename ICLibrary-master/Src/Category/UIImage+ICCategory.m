//
//  UIImage+ICCategory.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+ICCategory.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (ICCategory)

//截取部分图像
-(UIImage*)subImageAtRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
	
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    // 设置图片旋转方向
    //    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.0f orientation:self.imageOrientation];
    
    UIGraphicsEndImageContext();
    //    CGContextRelease(context);
	CFRelease(subImageRef);
    return smallImage;
}

//等比例缩放
-(UIImage*)imageScaledToSize:(CGSize)size 
{
	CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
	
	float verticalRadio = size.height*1.0/height; 
	float horizontalRadio = size.width*1.0/width;
	
	float radio = 1;
	if(verticalRadio>1 && horizontalRadio>1)
	{
		radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;	
	}
	else
	{
		radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;	
	}
	
	width = width*radio;
	height = height*radio;
	
    //	int xPos = (size.width - width)/2;
    //	int yPos = (size.height-height)/2;
	
	// 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
	
    // 绘制改变大小的图片  
    [self drawInRect:CGRectMake(0, 0, width, height)];  
	
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
	
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
	
    // 返回新的改变大小后的图片  
    return scaledImage;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
	
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	UIImage* subImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	
	return subImage;
	
}
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage ;
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor < heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	//   CGSize imageSize = sourceImage.size;
	//   CGFloat width = imageSize.width;
	//   CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	//   CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return newImage ;
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
	return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{ 
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
    
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}

- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor   
                           shadeAlpha1:(CGFloat)alpha1   
                           shadeAlpha2:(CGFloat)alpha2  
                           shadeAlpha3:(CGFloat)alpha3   
                           shadowColor:(UIColor *)shadowColor   
                          shadowOffset:(CGSize)shadowOffset   
                            shadowBlur:(CGFloat)shadowBlur {   
    UIImage *image = self;  
    CGColorRef cgColor = [bgColor CGColor];  
    CGColorRef cgShadowColor = [shadowColor CGColor];  
    CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};  
    CGFloat locations[4] = {0,0.5,0.6,1};  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);  
    CGRect contextRect;  
    contextRect.origin.x = 0.0f;  
    contextRect.origin.y = 0.0f;  
    contextRect.size = [image size];  
    //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);    
    // Retrieve source image and begin image context  
    UIImage *itemImage = image;  
    CGSize itemImageSize = [itemImage size];  
    CGPoint itemImagePosition;   
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);  
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);  
    UIGraphicsBeginImageContext(contextRect.size);  
    CGContextRef c = UIGraphicsGetCurrentContext();  
    // Setup shadow  
    CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);  
    // Setup transparency layer and clip to mask  
    CGContextBeginTransparencyLayer(c, NULL);  
    CGContextScaleCTM(c, 1.0, -1.0);  
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);  
    // Fill and end the transparency layer  
    CGContextSetFillColorWithColor(c, cgColor);       
    contextRect.size.height = -contextRect.size.height;  
    CGContextFillRect(c, contextRect);  
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);  
    CGContextEndTransparencyLayer(c);  
    //CGPointMake(contextRect.size.width*3.0/4.0, 0)  
    // Set selected image and end context  
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    CGColorSpaceRelease(colorSpace);  
    CGGradientRelease(colorGradient);  
    return resultImage;  
}



@end
