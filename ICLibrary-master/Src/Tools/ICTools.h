//
//  ICTools.h
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#pragma mark - Logging Messages to the Console

#ifdef DEBUG

//A simple wrapper for `NSLog()` that is automatically removed from release builds.
#define DLOG(...)   NSLog(__VA_ARGS__)

//More detailed loogging. Logs the function name and line number after the log message.
#define DLOGEXT(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//Logs a methodx call's class and selector.
#define DLOGCALL DLOG(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// Printf method
#define DLOGMETHOD	NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));

// Printf point ,include x and y
#define DLOGPOINT(p)	NSLog(@"%f,%f", p.x, p.y);

// Printf size ,include wide and height
#define DLOGSIZE(p)	NSLog(@"%f,%f", p.width, p.height);

// Printf size ,include  origin.x,origin.y,size.width and size.height
#define DLOGRECT(p)	NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#else
#define DLOG(...) /* */
#define DLOGEXT(...) /* */
#define DLOGCALL /* */
#define DLOGMETHOD /* */
#define DLOGPOINT(p) /* */
#define DLOGSIZE(p) /* */
#define DLOGRECT(p) /* */

#endif
