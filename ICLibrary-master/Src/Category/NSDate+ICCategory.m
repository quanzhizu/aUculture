//
//  NSDate+ICCategory.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+ICCategory.h"

@implementation NSDate (ICCategory)

+ (NSDate*)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString {
	if(!dateString) return nil;
	
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormatterString];
	
	NSDate *theDate = [formatter dateFromString:dateString];
	[formatter release];
	return theDate;
}

+ (NSDate*)dateWithISO8601String:(NSString*)dateString {
	if(!dateString) return nil;
	
	if([dateString hasSuffix:@" 00:00"]) {
		dateString = [[dateString substringToIndex:(dateString.length-6)] stringByAppendingString:@"GMT"];
	} else if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
}

+ (NSDate*)dateWithDateString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd"];
}

+ (NSDate*)dateWithDateTimeString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate*)dateWithLongDateTimeString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"dd MMM yyyy HH:mm:ss"];
}

+ (NSDate*)dateWithRSSDateString:(NSString*)dateString {
	if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
}

+ (NSDate*)dateWithAltRSSDateString:(NSString*)dateString {
	if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"d MMM yyyy HH:mm:ss ZZZ"];
}

- (NSString*)formattedExactRelativeDate {
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = now - time;
	
	if(diff < 10) {
        return [NSString stringWithFormat:@"刚刚"];
	} else if(diff < 60) {
        return [NSString stringWithFormat:@"%d seconds ago",(int)diff];
	}
	
	diff = round(diff/60);
	if(diff < 60) {
		if(diff == 1) {
            return [NSString stringWithFormat:@"%d minute ago",(int)diff];
		} else {
            return [NSString stringWithFormat:@"%d minutes ago",(int)diff];
		}
	}
	
	diff = round(diff/60);
	if(diff < 24) {
		if(diff == 1) {
            return [NSString stringWithFormat:@"%d hour ago",(int)diff];
		} else {
            return [NSString stringWithFormat:@"%d hours ago",(int)diff];
		}
	}
	
	if(diff < 7) {
		if(diff == 1) {
			return @"昨天";
		} else {
            return [NSString stringWithFormat:@"%d days ago", (int)diff];
		}
	}
	
	return [self formattedDateWithFormatString:@"MM/dd/yy"];
}	

- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString {
	if(!dateFormatterString) return nil;
	
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:dateFormatterString];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	return [formatter stringFromDate:self];
}

- (NSString*)formattedDate {
	return [self formattedDateWithFormatString:@"EEE, d MMM 'at' h:mma"];
}

- (NSString*)relativeFormattedDate {
    // Initialize the formatter.
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
	
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
	
    NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++) {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate* referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            // Today
			[formatter setDateStyle:NSDateFormatterNoStyle];
			[formatter setTimeStyle:NSDateFormatterShortStyle];
			break;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            // Yesterday
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"昨天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            // Day of the week
            return [[formatter weekdaySymbols] objectAtIndex:weekday];
        }
    }
	
    // It's not in those eight days.
    return [formatter stringFromDate:self];	
}

- (NSString*)relativeFormattedDateOnly {
    // Initialize the formatter.
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
	
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
	
    NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++) {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate* referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            // Today
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"今天";
       } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            // Yesterday
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"昨天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
            // Yesterday
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"明天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            // Day of the week
            return [[formatter weekdaySymbols] objectAtIndex:weekday];
        }
    }
	
    // It's not in those eight days.
    return [formatter stringFromDate:self];	
}

- (NSString*)relativeFormattedDateTime {
    // Initialize the formatter.
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
	
    NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++) {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate* referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            // Today
            [formatter setDateStyle:NSDateFormatterNoStyle];
  			return [NSString stringWithFormat:@"Today, %@", [formatter stringFromDate:self]];
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            // Yesterday
            [formatter setDateStyle:NSDateFormatterNoStyle];
			return [NSString stringWithFormat:@"Yesterday, %@", [formatter stringFromDate:self]];
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            // Day of the week
            NSString* day = [[formatter weekdaySymbols] objectAtIndex:weekday];
			[formatter setDateStyle:NSDateFormatterNoStyle];
			return [NSString stringWithFormat:@"%@, %@", day, [formatter stringFromDate:self]];
        }
    }
	
    // It's not in those eight days.
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
	NSString* date = [formatter stringFromDate:self];
	
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString* time = [formatter stringFromDate:self];
	
	return [NSString stringWithFormat:@"%@, %@", date, time];
}

- (NSString*)relativeLongFormattedDate {
    // Initialize the formatter.
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
	
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
	
    NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++) {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate* referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            // Today
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"今天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            // Yesterday
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"昨天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
            // Tomorrow
            [formatter setDateStyle:NSDateFormatterNoStyle];
            return @"明天";
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            // Day of the week
            return [[formatter weekdaySymbols] objectAtIndex:weekday];
        }
    }
	
    // It's not in those eight days.
    return [formatter stringFromDate:self];	
}

- (NSString*)formattedTime {
    // Initialize the formatter.
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	
    return [formatter stringFromDate:self];	
}

- (NSString*)iso8601Formatted {
	return [self formattedDateWithFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}

- (BOOL)isPastDate {
	NSDate* now = [NSDate date];
	if([[now earlierDate:self] isEqualToDate:self]) {
		return YES;
	} else {
		return NO;
	}	
}

- (BOOL)isDateToday {
	return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isDateYesterday {
	return [[[NSDate dateWithTimeIntervalSinceNow:-86400] midnightDate] isEqual:[self midnightDate]];
}

- (NSDate*)midnightDate {
	return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}

#pragma mark - Calendar
-(int)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}


-(int)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

-(int)day {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

-(int)firstWeekDayInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    //[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"]];
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

-(NSDate *)offsetMonth:(int)numMonths {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetHours:(int)hours {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //[offsetComponents setMonth:numMonths];
    [offsetComponents setHour:hours];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}



-(int)numDaysInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

+(NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: date];
    return [gregorian dateFromComponents:components];
}

+(NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

+(NSDate *)dateEndOfWeek {
    NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: + (((([components weekday] - [gregorian firstWeekday])
                                  + 7 ) % 7))+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: endOfWeek];
    
    //gestript
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}

@end
