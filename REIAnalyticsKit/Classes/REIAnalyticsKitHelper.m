//
//  ShopKitAnalyticsHelper.m
//  REI
//
//  Created by chris1 on 7/24/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "REIAnalyticsKitHelper.h"
#import "REIAnalyticsDataProvider.h"
#import "REIAnalyticsConfigurationLoader.h"
#import "REIObjectFactory.h"
#import "REIAnalyticsAdapter.h"

#import "REIAnalyticsKitAdobeHelper.h"

#import <NewRelicAgent/NewRelic.h>


@interface REIAnalyticsKitHelper ()
@property (nonatomic, strong) NSMutableArray *globalAnalyticsProviders;
@property (nonatomic, strong, nullable) dispatch_queue_t backgroundQueue;
@end

@implementation REIAnalyticsKitHelper

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[REIAnalyticsKitHelper alloc] init];
    });
    return singleton;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _backgroundQueue = dispatch_queue_create("REI Analytics VC Queue", NULL);
        
        [self loadGlobalAnalyticsProviders];
        [self loadGlobalAnalyticsAdapters];
    }
    
    return self;
}


- (void)loadGlobalAnalyticsProviders {
    self.globalAnalyticsProviders = [[NSMutableArray alloc] init];
    
    NSArray *dataProviderNames = [[REIAnalyticsConfigurationLoader shared] globalAnalyticsProviders];
    
    for (id globalDataProviderName in dataProviderNames) {
        NSObject *globalDataProvider = [REIObjectFactory createInstance:globalDataProviderName];
        if (globalDataProvider) {
            [self.globalAnalyticsProviders addObject:globalDataProvider];
        }
    }
}

- (void)loadGlobalAnalyticsAdapters {
    self.globalAnalyticsAdapters = [[NSMutableArray alloc] init];

    NSArray *adapters = [[REIAnalyticsConfigurationLoader shared] globalAnalyticsAdapters];
    
    for (id adapterName in adapters) {
        NSObject *adapter = [REIObjectFactory createInstance:adapterName];
        if (adapter) {
            [self.globalAnalyticsAdapters addObject:adapter];
        }
    }
}


- (void)dispatchAnalyticsEvent:(NSString *)eventName withContextData:(NSDictionary * _Nullable)contextData {
    __weak REIAnalyticsKitHelper *weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        [weakSelf notifyAdaptersOfEvent:eventName contextData:contextData];
    });
}

-(void) notifyAdaptersOfEvent:(NSString *)eventName contextData:(NSDictionary *)contextData {
    
    NSDictionary *aggregatedAnalyticsData = [self aggregateGlobalDataWithContextData:contextData];
    
    // iterate through all adapters and let them handle the event
    for (id gaa in self.globalAnalyticsAdapters) {
        NSObject <REIAnalyticsAdapter> *analyticsAdapter = (NSObject <REIAnalyticsAdapter> *)gaa;
        [analyticsAdapter handleEvent:eventName withContextData:aggregatedAnalyticsData];
    }
}

- (NSDictionary *)aggregateGlobalDataWithContextData:(NSDictionary *)contextData {
    NSMutableDictionary *aggregatedAnalyticsData = [[NSMutableDictionary alloc] init];
    
    // add data from global data providers
    for (id gdp in self.globalAnalyticsProviders) {
        NSObject <REIAnalyticsDataProvider> *dataProvider = (NSObject <REIAnalyticsDataProvider> *) gdp;
        NSDictionary *analyticsData = [dataProvider getAnalyticsData];
        [aggregatedAnalyticsData addEntriesFromDictionary:analyticsData];
    }
    
    // add data from caller
    [aggregatedAnalyticsData addEntriesFromDictionary:contextData];
    
    return  aggregatedAnalyticsData;
}


// adobe stuff
//- (void)configureAdobeAnalytics:(NSString *)configFile appGroup:(nullable NSString *)appGroup {
//    [[REIAnalyticsKitAdobeHelper shared] configureAdobeAnalytics:configFile appGroup:appGroup];
//}

- (void)configureAdobeAnalytics: (NSString *)adobeApplicationId {
    [[REIAnalyticsKitAdobeHelper shared] configureAdobeAnalytics:adobeApplicationId];
}

- (void)setAdobeAnalyticsAppGroup:(NSString *)appGroup {
    [[REIAnalyticsKitAdobeHelper shared] setAdobeAnalyticsAppGroup:appGroup];
}

- (NSString*)adobeCloudMarketingId {
    return [[REIAnalyticsKitAdobeHelper shared] cloudMarketingId];
}

- (NSString *)firstAdobeTrackingIdentifier {
    return [[REIAnalyticsKitAdobeHelper shared] firstTrackingIdentifier];
}

- (void)adobeABTestWithName:(nullable NSString *)name
             defaultContent:(nullable NSString *)defaultContent
                 parameters:(nullable NSDictionary *)parameters
                   callback:(nullable void (^)(NSString* __nullable content))callback {
    [[REIAnalyticsKitAdobeHelper shared] adobeABTestWithName:name defaultContent:defaultContent parameters:parameters callback:callback];
}




// new relic
- (void)configureNewRelicAnalytics:(NSString *)applicationToken {
    [NewRelicAgent startWithApplicationToken:applicationToken];
}

@end
