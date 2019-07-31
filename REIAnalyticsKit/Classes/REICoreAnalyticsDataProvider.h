//
//  REICoreAnalyticsDataProvider.h
//  REI
//
//  Created by chris1 on 7/29/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "REIAnalyticsDataProvider.h"


NS_ASSUME_NONNULL_BEGIN

// PAGE LEVEL ANALYTICS
FOUNDATION_EXPORT NSString * const REIAnalyticsPageNameKey;
FOUNDATION_EXPORT NSString * const REIAnalyticsChannelKey;
FOUNDATION_EXPORT NSString * const REIAnalyticsSubSection1Key;
FOUNDATION_EXPORT NSString * const REIAnalyticsSubSection2Key;
FOUNDATION_EXPORT NSString * const REIAnalyticsSubSection3Key;
FOUNDATION_EXPORT NSString * const REIAnalyticsTemplateTypeKey;
FOUNDATION_EXPORT NSString * const REIAnalyticsSiteIdKey;
FOUNDATION_EXPORT NSString * const REIAnalyticsContentTypeKey;


@protocol REIAnalyticsContextDataSource <NSObject>
@required
- (NSString *)analyticsPageName;
- (NSString *)analyticsChannel;
- (NSString *)analyticsSubSection1;
- (NSString *)analyticsSubSection2;
- (NSString *)analyticsSubSection3;
- (NSString *)analyticsTemplateType;
- (NSString *)analyticsSiteId;
- (NSString *)analyticsContentType;
- (NSString *)analyticsProductsString;
@optional
- (nullable NSDictionary *)analyticsAdditionalContext;
@end


@interface REICoreAnalyticsDataProvider : NSObject <REIAnalyticsDataProvider>

+ (instancetype)shared;

- (void)appWillEnterForeground;
- (void)appDidEnterBackground;
- (void)pageVisited;

@end

NS_ASSUME_NONNULL_END
