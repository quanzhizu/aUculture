//
//  NSURL+ICCategory.h
//  WhiteBook2
//
//  Created by Fox on 13-1-29.
//  Copyright (c) 2013年 c1618. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQUEST_TIME_OUT_INTERVAL 30

@interface NSURL (ICCategory)

- (NSURLRequest *)toURLRequest;
- (NSMutableURLRequest *)toMutableURLRequest;

@end
