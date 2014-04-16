//
//  NSDate+ICCategory.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ICCategory)

@property(nonatomic,readonly,getter=isEmpty) BOOL empty;

@end


@interface NSData (Base64Helper)

+ (NSData *)dataFromBase64EncodedString:(NSString *)aString;
- (NSString *)base64EncodedString;

@end