//
//  ShopAnalyticsConfigurationLoader.h
//  REI
//
//  Created by chris1 on 7/25/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface REIAnalyticsConfigurationLoader : NSObject

+ (instancetype)shared;

- (NSArray *)globalAnalyticsProviders;
- (NSArray *)globalAnalyticsAdapters;
- (NSDictionary *)globalDefaults;
- (NSDictionary *)defaultsForClass:(NSString *)className;
- (NSDictionary *)contextDataForClass:(NSString *)className;
- (NSArray *)adaptersForClass:(NSString *)className;

@end

//NS_ASSUME_NONNULL_END
