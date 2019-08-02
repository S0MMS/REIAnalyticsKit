//
//  REIDefaultAnalyticsDataProvider.m
//  ACPAnalytics
//
//  Created by chris1 on 8/2/19.
//

#import "REIDefaultAnalyticsDataProvider.h"

#import "REIAnalyticsConfigurationLoader.h"

@implementation REIDefaultAnalyticsDataProvider

- (NSDictionary * _Nullable)getAnalyticsData {
    return [[REIAnalyticsConfigurationLoader shared] globalDefaults];
}

@end
