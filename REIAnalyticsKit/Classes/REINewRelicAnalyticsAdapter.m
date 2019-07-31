//
//  NewNewRelicAnalyticsAdapter.m
//  REI
//
//  Created by chris1 on 7/26/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "REINewRelicAnalyticsAdapter.h"

// CKS: REIAnalyticsKit - FIX
#import <NewRelicAgent/NewRelic.h>


static NSString * const kSearchGridTapMetricName = @"search_product view";
static NSString * const kProductDetailViewMetricName = @"rei:product details";
static NSString * const kMetricValueKey = @"metricValue";


@implementation REINewRelicAnalyticsAdapter

- (void)handleEvent:(NSString *)eventName withContextData:(NSDictionary *)contextData {

    if ([eventName hasPrefix:kSearchGridTapMetricName] || [eventName hasPrefix:kProductDetailViewMetricName]) {
        NSString *metricName = [eventName hasPrefix:kSearchGridTapMetricName] ? kSearchGridTapMetricName : kProductDetailViewMetricName;
        NSString *metricValue = [eventName substringFromIndex:(metricName.length + 1)];

        [NewRelic setAttribute:kMetricValueKey value:metricValue];
        [NewRelic startInteractionWithName:eventName];
        [NewRelic removeAttribute:kMetricValueKey];

    } else {
        [NewRelic startInteractionWithName:eventName];
    }
}


@end
