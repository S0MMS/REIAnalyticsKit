//
//  AnalyticsAdapter.h
//  Forest
//
//  Created by Chris Shreve on 4/6/16.
//  Copyright © 2016 REI. All rights reserved.
//

@import Foundation;

@protocol REIAnalyticsAdapter <NSObject>

- (void)handleEvent:(nonnull NSString *)eventName withContextData:(nullable NSDictionary *)contextData;

@end

