//
//  REIAnalyticsHelper.h
//  REI iPad
//
//  Created by Mark Wells on 5/25/14.
//  Copyright (c) 2014 Deloitte Digital. All rights reserved.
//

@import Foundation;

#import "REICoreAnalyticsDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface REIAnalyticsKitAdobeHelper : NSObject

+ (instancetype)shared;

- (void)trackState:(NSString *)state withContextData:(NSDictionary * _Nullable)contextData;

- (void)trackAction:(NSString *)action withContextData:(NSDictionary * _Nullable)contextData;

- (void)configureAdobeAnalytics: (NSString *)adobeApplicationId;

- (void)setAdobeAnalyticsAppGroup:(NSString *)appGroup;
- (NSString *)cloudMarketingId;
- (NSString *)firstTrackingIdentifier;
- (NSArray *)trackingIdentifiers;
- (void)testWithName:(nullable NSString *)name
             defaultContent:(nullable NSString *)defaultContent
                 parameters:(nullable NSDictionary *)parameters
                   callback:(nullable void (^)(NSString* __nullable content))callback;


NS_ASSUME_NONNULL_END


@end

