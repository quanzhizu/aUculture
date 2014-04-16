//
//  ICPhoto.m
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICPhoto.h"

// Private
@interface ICPhoto ()
{
    // Image Sources
    NSString *_photoPath;
    NSURL *_photoURL;
    
    // Image
    UIImage *_underlyingImage;
    
    // Other
    NSString *_caption;
    BOOL _loadingInProgress;
}

// Methods
- (void)imageDidFinishLoadingSoDecompress;
- (void)imageLoadingComplete;

@end


@implementation ICPhoto

// Properties
@synthesize underlyingImage = _underlyingImage, 
caption = _caption;

#pragma mark Class Methods

+ (ICPhoto *)photoWithImage:(UIImage *)image {
	return [[[ICPhoto alloc] initWithImage:image] autorelease];
}

+ (ICPhoto *)photoWithFilePath:(NSString *)path {
	return [[[ICPhoto alloc] initWithFilePath:path] autorelease];
}

+ (ICPhoto *)photoWithURL:(NSURL *)url {
	return [[[ICPhoto alloc] initWithURL:url] autorelease];
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		self.underlyingImage = image;
	}
	return self;
}

- (id)initWithFilePath:(NSString *)path {
	if ((self = [super init])) {
		_photoPath = [path copy];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

- (void)dealloc {
    [_caption release];
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
	[_photoPath release];
	[_photoURL release];
	[_underlyingImage release];
	[super dealloc];
}

#pragma mark MWPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    _loadingInProgress = YES;
    if (self.underlyingImage) {
        // Image already loaded
        [self imageLoadingComplete];
    } else {
        if (_photoPath) {
            // Load async from file
            [self performSelectorInBackground:@selector(loadImageFromFileAsync) withObject:nil];
        } else if (_photoURL) {
            // Load async from web (using SDWebImage)
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            UIImage *cachedImage = [manager imageWithURL:_photoURL];
            if (cachedImage) {
                // Use the cached image immediatly
                self.underlyingImage = cachedImage;
                [self imageDidFinishLoadingSoDecompress];
            } else {
                // Start an async download
                [manager downloadWithURL:_photoURL delegate:self];
            }
        } else {
            // Failed - no source
            self.underlyingImage = nil;
            [self imageLoadingComplete];
        }
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
	if (self.underlyingImage && (_photoPath || _photoURL)) {
		self.underlyingImage = nil;
	}
}

#pragma mark - Async Loading

// Called in background
// Load image in background from local file
- (void)loadImageFromFileAsync {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:_photoPath options:NSDataReadingUncached error:&error];
        if (!error) {
            self.underlyingImage = [[[UIImage alloc] initWithData:data] autorelease];
        } else {
            self.underlyingImage = nil;
        }
    } @catch (NSException *exception) {
    } @finally {
        [self performSelectorOnMainThread:@selector(imageDidFinishLoadingSoDecompress) withObject:nil waitUntilDone:NO];
        [pool drain];
    }
}

// Called on main
- (void)imageDidFinishLoadingSoDecompress {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.underlyingImage) {
        // Decode image async to avoid lagging when UIKit lazy loads
        [[SDWebImageDecoder sharedImageDecoder] decodeImage:self.underlyingImage withDelegate:self userInfo:nil];
    } else {
        // Failed
        [self imageLoadingComplete];
    }
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ICPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

#pragma mark - SDWebImage Delegate

// Called on main
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    self.underlyingImage = image;
    [self imageDidFinishLoadingSoDecompress];
}

// Called on main
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error {
    self.underlyingImage = nil;
    [self imageDidFinishLoadingSoDecompress];
}

// Called on main
- (void)imageDecoder:(SDWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)userInfo {
    // Finished compression so we're complete
    self.underlyingImage = image;
    [self imageLoadingComplete];
}



@end
