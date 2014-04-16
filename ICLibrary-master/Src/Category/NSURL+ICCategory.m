//
//  NSURL+ICCategory.m
//  WhiteBook2
//
//  Created by Fox on 13-1-29.
//  Copyright (c) 2013年 c1618. All rights reserved.
//

#import "NSURL+ICCategory.h"

@implementation NSURL (ICCategory)

- (NSURLRequest *)toURLRequest {
	return [NSURLRequest requestWithURL:self
							cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:REQUEST_TIME_OUT_INTERVAL];
}

- (NSMutableURLRequest *)toMutableURLRequest {
	return [NSMutableURLRequest requestWithURL:self
								   cachePolicy:NSURLRequestUseProtocolCachePolicy
							   timeoutInterval:REQUEST_TIME_OUT_INTERVAL];
}

@end
