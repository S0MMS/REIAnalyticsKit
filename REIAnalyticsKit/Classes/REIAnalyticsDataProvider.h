//
//  REIAuxilaryAnalyticsDataProvider.h
//  REI
//
//  Created by chris1 on 7/28/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol REIAnalyticsDataProvider <NSObject>

- (NSDictionary * _Nullable)getAnalyticsData;

@end

NS_ASSUME_NONNULL_END
