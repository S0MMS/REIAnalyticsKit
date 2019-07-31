//
//  ShopAnalyticsProvider.h
//  REI
//
//  Created by chris1 on 7/25/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol REIAnalyticsDispatcher <NSObject>

// initialization
- (void)configureAnalytics;
- (void)clearAnalytics;

// data write
- (void)setAnalyticsChannel:(NSString * _Nonnull)channel;
- (void)setAnalyticsPageName:(NSString * _Nonnull)pageName;
- (void)setAnalyticsSubSection1:(NSString * _Nonnull)subSection1;
- (void)setAnalyticsSubSection2:(NSString * _Nonnull)subSection2;
- (void)setAnalyticsProductString:(NSString * _Nonnull)productString;
- (void)setAnalyticsTemplateType:(NSString * _Nonnull)templateType;
- (void)setAdditionalAnalyticsContextData:(NSDictionary<NSString*, NSString*>* _Nonnull)contextData;
- (void)updateAnalyticsWithDictionary:(NSDictionary<NSString *, NSString *> * _Nonnull)dictionary;
- (void)setAnalyticsParameter:(NSString *)key value:(NSString *)value;  // should have been in other protocol

// data read
- (NSDictionary * _Nullable)getAnalyticsContextData;
- (NSString * _Nullable)getAnalyticsPageName;                           // should have been in other protocol

// control
- (void)deferTrackState;                                                // should have been in other protocol

// dispatching
- (void)dispatchAnalyticsEvent;
- (void)dispatchAnalyticsEvent:(NSString * _Nonnull)eventName;
- (void)dispatchAnalyticsEvent:(NSString * _Nonnull)eventName contextData:(NSDictionary * _Nullable)contextData;

@end

NS_ASSUME_NONNULL_END
