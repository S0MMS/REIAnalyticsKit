//
//  REICoreAnalyticsDataProvider.m
//  REI
//
//  Created by chris1 on 7/29/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "REICoreAnalyticsDataProvider.h"

@import Foundation;
@import UIKit;

NSString * const REIAnalyticsSavedDatesOfVisitsKey = @"lastVisitDates";
static const NSTimeInterval REIAnalyticsMaxBackgroundIntervalForSession = 1800; // 30 minutes (unit is seconds)
static const NSTimeInterval REIAnalyticsMaxVisitIntervalTime = 30*24*60*60; //30 days


// GLOBAL LEVEL ANALYTICS
NSString * const REIAnalyticsUserTokenKey = @"rei.userToken";
NSString * const REIAnalyticsiPhoneVisitEventKey = @"rei.app1Event";
NSString * const REIAnalyticsiPadVisitEventKey = @"rei.app3Event";
NSString * const REIAnalyticsFirstTimeVisitEventKey = @"rei.firstTimeVisitEvent";
NSString * const REIAnalyticsRepeatVisitEventKey = @"rei.repeatVisitEvent";
NSString * const REIAnalyticsRepeatVisitKey = @"rei.isRepeat";
NSString * const REIAnalyticsTotalVisitCountKey = @"rei.totalVisitCount";
NSString * const REIAnalyticsVisitDateKey = @"rei.visitDate";
NSString * const REIAnalyticsPageNumberKey = @"rei.pageNumber";
NSString * const REIAnalyticsPageViewEventKey = @"rei.pageViewEvent";
NSString * const REIAnalyticsMobileVisitEventKey = @"rei.mobileVisit";
NSString * const REIAnalyticsSavedLastAppBackgroundKey = @"lastAppBackgroundTimestamp";

// PAGE LEVEL ANALYTICS
NSString * const REIAnalyticsPageNameKey = @"rei.pagename";
NSString * const REIAnalyticsChannelKey = @"rei.channel";
NSString * const REIAnalyticsSubSection1Key = @"rei.subSection1";
NSString * const REIAnalyticsSubSection2Key = @"rei.subSection2";
NSString * const REIAnalyticsSubSection3Key = @"rei.subSection3";
NSString * const REIAnalyticsTemplateTypeKey = @"rei.templateType";
NSString * const REIAnalyticsContentTypeKey = @"rei.contentType";
NSString * const REIAnalyticsSiteIdKey = @"rei.siteID";

@interface REICoreAnalyticsDataProvider ()

// Properties to maintain counts of visits and activity during visits
@property (nonatomic) NSString * userToken;                 // user token is set on first launch and persisted in user defaults
@property (nonatomic) NSMutableArray* visitDates;           // array of dates of the last visits is persisted in user defaults
@property (nonatomic) NSDate *lastAppBackgroundTimestamp;   // persisted in user defaults
@property (nonatomic) NSString *visitTimeString;            // timestamp (to the nearest 15 mins) that the current visit started (format "8:15 PM|Tuesday")
@property (nonatomic) NSInteger visitPageNumber;            // total number of pages viewed during current visit/session

@property (nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation REICoreAnalyticsDataProvider

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[REICoreAnalyticsDataProvider alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US"];
        self.dateFormatter.dateFormat = @"h:mm a|EEEE";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Fetch the lastAppBackgroundTimestamp
        if ([defaults objectForKey:REIAnalyticsSavedLastAppBackgroundKey]) {
            self.lastAppBackgroundTimestamp = (NSDate *)[defaults objectForKey:REIAnalyticsSavedLastAppBackgroundKey];
        }
        
        if ([defaults objectForKey:REIAnalyticsUserTokenKey]) {
            self.userToken = [defaults objectForKey:REIAnalyticsUserTokenKey];
        }
        else {
            [self generateUserToken];
            [defaults setObject:self.userToken forKey:REIAnalyticsUserTokenKey];
        }
        
        [self generateVisitTimestampString];
    }
    return self;
}

- (void)generateUserToken
{
    NSString *tokenString = [[NSUUID UUID] UUIDString];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tokenString = [tokenString lowercaseString];
    
    self.userToken = tokenString;
}

- (void)generateVisitTimestampString
{
    NSDate *date = [NSDate date];
    
    NSDateComponents *time = [[NSCalendar currentCalendar]
                              components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                              fromDate: date];
    
    NSInteger fifteenMinutesInSecounds = 15 * 60;
    NSInteger remainder = (([time minute] * 60 + [time second]) % fifteenMinutesInSecounds);
    if (remainder < (fifteenMinutesInSecounds / 2))
    {
        date = [date dateByAddingTimeInterval: -remainder];
    }
    else
    {
        date = [date dateByAddingTimeInterval: fifteenMinutesInSecounds - remainder];
    }
    
    self.visitTimeString = [self.dateFormatter stringFromDate:date];
}

- (NSMutableDictionary *)globalData
{
    NSString *firstOrRepeatVisitEventKey = (self.visitDates.count == 1) ? REIAnalyticsFirstTimeVisitEventKey : REIAnalyticsRepeatVisitEventKey;
    
    NSString *platformCode = @"app1"; // iPhone
    NSString *platformAppKey = REIAnalyticsiPhoneVisitEventKey;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        platformCode = @"app3";
        platformAppKey = REIAnalyticsiPadVisitEventKey;
    }
    
    NSString *visitPageNumberString = [NSString stringWithFormat:@"%ld", (long)self.visitPageNumber];
    
    NSMutableDictionary *data = [@{ REIAnalyticsRepeatVisitKey : (self.visitDates.count == 1) ? @"New" : @"Repeat",
                                    REIAnalyticsUserTokenKey : self.userToken ? self.userToken : @"UNKNOWN",
                                    REIAnalyticsTotalVisitCountKey : [NSString stringWithFormat:@"%lu", (unsigned long)self.visitDates.count],
                                    REIAnalyticsVisitDateKey : self.visitTimeString,
                                    REIAnalyticsPageNumberKey : visitPageNumberString,
                                    firstOrRepeatVisitEventKey : @"1",
                                    REIAnalyticsPageViewEventKey : @"1",
                                    platformAppKey : @"1",
                                    REIAnalyticsMobileVisitEventKey : platformCode
                                    } mutableCopy];
    return data;
}

//-------------------------------------------------
#pragma mark - AppDelegate callback methods
//-------------------------------------------------
- (void)appWillEnterForeground {
    // Check to see if the app has been in background long enough to consider this a new session
    BOOL isNewVisit = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:REIAnalyticsSavedLastAppBackgroundKey]) {
        self.lastAppBackgroundTimestamp = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:REIAnalyticsSavedLastAppBackgroundKey];
    }
    if (self.lastAppBackgroundTimestamp) {
        NSDate *currentSessionExpiryDate = [self.lastAppBackgroundTimestamp dateByAddingTimeInterval:REIAnalyticsMaxBackgroundIntervalForSession];
        if ([currentSessionExpiryDate compare:[NSDate date]] == NSOrderedDescending) {
            isNewVisit = NO;
        }
    }
    if (isNewVisit) {
        [self updateVisitDates:YES];
        [self generateVisitTimestampString];
        self.visitPageNumber = 0;
    }
    else {
        [self updateVisitDates:NO];
    }
}

- (void)updateVisitDates:(BOOL)shouldAddCurrentTimestamp
{
    // Fetch the last visits and optionally add current timestamp

    NSArray *dates = [[NSUserDefaults standardUserDefaults] objectForKey:REIAnalyticsSavedDatesOfVisitsKey];

    if (dates)
    {
        NSMutableArray *currentDates = [[NSMutableArray alloc] initWithCapacity:dates.count];
        NSDate *earlyCutoffDate = [[NSDate date] dateByAddingTimeInterval:-REIAnalyticsMaxVisitIntervalTime];

        for (NSDate *date in dates)
        {
            if ([[date laterDate:earlyCutoffDate] isEqualToDate:date])
            {
                [currentDates addObject:date];
            }
        }
        if (shouldAddCurrentTimestamp) {
            [currentDates addObject:[NSDate date]];
        }
        self.visitDates = currentDates;
    }
    else
    {
        self.visitDates = [[NSMutableArray alloc] initWithObjects:[NSDate date], nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.visitDates forKey:REIAnalyticsSavedDatesOfVisitsKey];
}

- (void)appDidEnterBackground {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:REIAnalyticsSavedLastAppBackgroundKey];
}

- (void)pageVisited {
    self.visitPageNumber++;
}

//-------------------------------------------------
#pragma mark - REIAuxilaryAnalyticsDataProvider
//-------------------------------------------------
- (NSDictionary * _Nullable)getAnalyticsData {
    // get the singleton global data
    return [[REICoreAnalyticsDataProvider shared] globalData];
}

@end
