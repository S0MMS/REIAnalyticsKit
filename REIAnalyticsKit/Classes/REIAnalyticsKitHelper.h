//
//  ShopKitAnalyticsHelper.h
//  REI
//
//  Created by chris1 on 7/24/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REIAnalyticsKitHelper : NSObject

@property (nonatomic, strong) NSMutableArray *globalAnalyticsAdapters;

+ (instancetype)shared;

// global stuff
- (void)dispatchAnalyticsEvent:(NSString *)eventName withContextData:(NSDictionary * _Nullable)contextData;
- (NSDictionary *)aggregateGlobalDataWithContextData:(NSDictionary *)contextData;


// adobe stuff
- (void)configureAdobeAnalytics: (NSString *)adobeApplicationId;
- (void)setAdobeAnalyticsAppGroup:(NSString *)appGroup;
- (NSString *)adobeCloudMarketingId;
- (NSString *)firstAdobeTrackingIdentifier;
- (void)adobeABTestWithName:(nullable NSString *)name
             defaultContent:(nullable NSString *)defaultContent
                 parameters:(nullable NSDictionary *)parameters
                   callback:(nullable void (^)(NSString* __nullable content))callback;


// new relic stuff
- (void)configureNewRelicAnalytics:(NSString *)applicationToken;

@end

NS_ASSUME_NONNULL_END
