//
//  EGOImageView.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOImageScaleView.h"
#import "EGOImageLoader.h"
#import "UIImage+ScaleAndCrop.h"

@implementation EGOImageScaleView
@synthesize imageURL, placeholderImage, delegate, imgLoaded, spinner;

- (id)initWithPlaceholderImage:(UIImage*)anImage 
{
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageScaleViewDelegate>)aDelegate
{
	if((self = [super initWithImage:anImage]))
    {
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
        imgLoaded = NO;
        
        // muestro una precarga hasta que se cargue la imagen
        CGRect frmSpinner = CGRectMake((self.frame.size.width/2)-12, (self.frame.size.height/2)-12, 24, 24);
        self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:frmSpinner];
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
	}
	
	return self;
}

- (void)setImageURL:(NSURL *)aURL 
{
    imgLoaded = NO;
	if(imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	if(!aURL) {
		self.image = self.placeholderImage;
		imageURL = nil;
		return;
	} else {
		imageURL = [aURL retain];
	}

	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
	if(anImage)
    {
        imgLoaded = YES;
        
        CGRect fra = self.frame;
        anImage = [anImage imageByScalingAndCroppingForSize:fra.size];
		self.image = anImage;
        [self.spinner removeFromSuperview];

		// trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
			[self.delegate imageViewLoadedImage:self];
		}
	}
    else
    {
		self.image = self.placeholderImage;
	}
}

- (void) setPlaceholderImage:(UIImage *)aPlaceholderImage
{
    //[self cancelImageLoad];
    [self.spinner removeFromSuperview];
    self.image = aPlaceholderImage;
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
    imgLoaded = NO;
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification 
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;

	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
	self.image = anImage;
    [self.spinner removeFromSuperview];
	[self setNeedsDisplay];
    imgLoaded = YES;
	
	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) 
    {
		[self.delegate imageViewLoadedImage:self];
	}	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification 
{
    imgLoaded = NO;
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
		[self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
	}
}

#pragma mark -
- (void)dealloc 
{
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.imageURL = nil;
	self.placeholderImage = nil;
    self.spinner = nil;
    
    [super dealloc];
}

@end