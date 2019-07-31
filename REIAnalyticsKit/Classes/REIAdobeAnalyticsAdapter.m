
//
//  AdobeAnalyticsAdapter.m
//  REI
//
//  Created by Chris Shreve on 4/11/16.
//  Copyright © 2016 REI. All rights reserved.
//

#import "REIAdobeAnalyticsAdapter.h"
#import "REIAnalyticsKitAdobeHelper.h"

typedef NS_ENUM(NSUInteger, EventType) {
    EventTypeAdobeTrackState,
    EventTypeAdobeTrackAction,
};

@interface REIAdobeAnalyticsAdapter()

@property (nonatomic, strong) REIAnalyticsKitAdobeHelper *helper;

@end


@implementation REIAdobeAnalyticsAdapter

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.helper = [REIAnalyticsKitAdobeHelper shared];
    }
    
    return self;
}

- (void)handleEvent:(NSString *)eventName withContextData:(NSDictionary *)contextData
{
    EventType eventType = [self eventTypeForString:eventName];
    
    switch (eventType) {
        case EventTypeAdobeTrackState: {
            [self.helper trackState:eventName withContextData:contextData];
            [[REICoreAnalyticsDataProvider shared] pageVisited];
            break;
        }
        case EventTypeAdobeTrackAction: {
            [self.helper trackAction:eventName withContextData:contextData];
            break;
        }
    }
}

-(EventType)eventTypeForString:(NSString *)eventName
{
    /*
     If we don't have a page name, it can only be a track-action
     */
    if (!self.analyticsPageName) {
        return EventTypeAdobeTrackAction;
    }

    
    BOOL eventHasPagenamePrefix = [eventName hasPrefix:self.analyticsPageName];
    BOOL eventIsEqualToPageName = [eventName isEqualToString:self.analyticsPageName];
    
    /*
     !!!: Investigate for change
     warning: This checking for a prefix can an falsely report a track-action as a track-state
        page name: rei:store_WA_Seattle
        event name: rei:store_WA_Seattle_map
     
     consider: check for eventName being equal to pageName
     */
    EventType eventType = EventTypeAdobeTrackAction;

    // !!!: Consider changing this to `isEqualToString:`
    if (self.analyticsPageName && eventHasPagenamePrefix) {
        eventType = EventTypeAdobeTrackState;
    }
    
    // workaround for stores page
    BOOL isStorePagePrefix = [eventName hasPrefix:@"rei:store_"];
    if (isStorePagePrefix) {
        if (eventIsEqualToPageName) {
            return EventTypeAdobeTrackState;
        }
        else {
            return EventTypeAdobeTrackAction;
        }
    }
    
    return eventType;
}

@end
