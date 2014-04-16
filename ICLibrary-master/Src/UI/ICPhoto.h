//
//  ICPhoto.h
//  iChanceSample
//
//  Created by Fox on 12-12-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPhotoProtocol.h"
#import "SDWebImageDecoder.h"
#import "SDWebImageManager.h"
#import "ICTools.h"


// This class models a photo/image and it's caption
// If you want to handle photos, caching, decompression
// yourself then you can simply ensure your custom data model
// conforms to ICPhotoProtocol
@interface ICPhoto : NSObject <ICPhoto, SDWebImageManagerDelegate, SDWebImageDecoderDelegate>

// Properties
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *underlyingImage;


// Class
+ (ICPhoto *)photoWithImage:(UIImage *)image;
+ (ICPhoto *)photoWithFilePath:(NSString *)path;
+ (ICPhoto *)photoWithURL:(NSURL *)url;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

@end
