//
//  AnalyticsViewControllerNEW.h
//  REI
//
//  Created by chris1 on 7/25/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "REICoreAnalyticsDataProvider.h"

//NS_ASSUME_NONNULL_BEGIN

@interface REIAnalyticsViewController : UIViewController <REIAnalyticsContextDataSource>

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *subSection1;
@property (nonatomic, strong) NSString *subSection2;
@property (nonatomic, strong) NSString *productsString;
@property (nonatomic, strong) NSString *templateType;
@property (nonatomic, strong) NSMutableDictionary *additionalContext;

- (instancetype)initWithHostingClassName:(NSString *)hostingClassName;
- (void)updateWithDictionary:(NSDictionary *)dictionary;
- (void)handleEvent:(NSString *)eventName contextData:(NSDictionary *)contextData;

// this must be viewable by the category!
- (void)removeAnalytics;
- (NSDictionary *)asContextData;

- (void)deferTrack;

@end

//NS_ASSUME_NONNULL_END
