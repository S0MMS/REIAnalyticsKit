//
//  AnalyticsViewControllerNEW.m
//  REI
//
//  Created by chris1 on 7/25/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "REIAnalyticsViewController.h"
#import "REIAnalyticsConfigurationLoader.h"
#import "REIObjectFactory.h"
#import "REIAnalyticsKitHelper.h"
#import "REICoreAnalyticsDataProvider.h"

#import "REIAnalyticsAdapter.h"
#import "REIAdobeAnalyticsAdapter.h"
#import "REINewRelicAnalyticsAdapter.h"

typedef NS_ENUM(NSUInteger, TrackState) {
    TrackStateOnAppear,
    TrackStateOnLoad,
    TrackStateDefer
};

static NSString * const kTrackStateKey = @"trackState";

@interface REIAnalyticsViewController ()

@property (nonatomic, strong) NSString *hostingClassName;

@property (nonatomic) TrackState trackState;

@property (nonatomic, strong) NSString *contentType;

@property (nonatomic, strong) NSString *siteId;

@property (nonatomic, strong) NSString *subSection3;

@property (nonatomic, strong) NSMutableArray *adapters;

@property (nonatomic, strong, nullable) dispatch_queue_t backgroundQueue;

@end

@implementation REIAnalyticsViewController

- (instancetype) initWithHostingClassName:(NSString *)hostingClassName {
    self = [super init];
    
    if (self) {
        _hostingClassName = hostingClassName;
        
        _trackState = TrackStateOnAppear;
        
        _backgroundQueue = dispatch_queue_create("REI Analytics VC Queue", NULL);
        
        // ensure not visible
        self.view.frame = CGRectZero;
        self.view.alpha = 0.0;
 
        [self configureWithDefaults];
        [self configureContextData];
        [self configureAdapters];
    }
    
    return self;
}

- (void)configureWithDefaults {
    NSDictionary *defaultData = [[REIAnalyticsConfigurationLoader shared] defaultsForClass:self.hostingClassName];
    if (defaultData) {
        [self updateWithDictionary:defaultData];
    }
}

// this must be visible to the category!
- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if (dictionary[REIAnalyticsPageNameKey]) {
        self.pageName = dictionary[REIAnalyticsPageNameKey];
    }
    
    if (dictionary[REIAnalyticsChannelKey]) {
        self.channel = dictionary[REIAnalyticsChannelKey];
    }
    
    if (dictionary[REIAnalyticsContentTypeKey]) {
        self.contentType = dictionary[REIAnalyticsContentTypeKey];
    }
    
    if (dictionary[REIAnalyticsSiteIdKey]) {
        self.siteId = dictionary[REIAnalyticsSiteIdKey];
    }
    
    if (dictionary[REIAnalyticsSubSection1Key]) {
        self.subSection1 = dictionary[REIAnalyticsSubSection1Key];
    }

    if (dictionary[REIAnalyticsSubSection2Key]) {
        self.subSection2 = dictionary[REIAnalyticsSubSection2Key];
    }

    if (dictionary[REIAnalyticsSubSection3Key]) {
        self.subSection3 = dictionary[REIAnalyticsSubSection3Key];
    }

    if (dictionary[REIAnalyticsTemplateTypeKey]) {
        self.templateType = dictionary[REIAnalyticsTemplateTypeKey];
    }
    
    if (dictionary[kTrackStateKey]) {
        NSString *trackWhen  = dictionary[kTrackStateKey];
        
        if ([trackWhen isEqualToString:@"defer"]) {
            self.trackState = TrackStateDefer;
        } else if ([trackWhen isEqualToString:@"onLoad"]) {
            self.trackState = TrackStateOnLoad;
        } else {
            self.trackState = TrackStateOnAppear;
        }
    }
}

#pragma mark - REIAnalyticsHelperContextDataSource
- (nonnull NSString *)analyticsChannel {
    return self.channel ? self.channel : @"";
}

- (nonnull NSString *)analyticsContentType {
    return self.contentType ? self.contentType : @"";
}

- (nonnull NSString *)analyticsPageName {
    return self.pageName ? self.pageName : [NSString stringWithFormat:@"rei:%@", self.hostingClassName];
}

- (nonnull NSString *)analyticsProductsString {
    return self.productsString ? self.productsString : @"";
}

- (nonnull NSString *)analyticsSiteId {
    return self.siteId ? self.siteId : @"";
}

- (nonnull NSString *)analyticsSubSection1 {
    return self.subSection1 ? self.subSection1 : @"";
}

- (nonnull NSString *)analyticsSubSection2 {
    return self.subSection2 ? self.subSection2 : @"";
}

- (nonnull NSString *)analyticsSubSection3 {
    return self.subSection3 ? self.subSection3 : @"";
}

- (nonnull NSString *)analyticsTemplateType {
    return self.templateType ? self.templateType : @"";
}

- (nullable NSDictionary *)analyticsAdditionalContext {
    return self.additionalContext;
}


// this must be visible to the category!
- (void)removeAnalytics {
    self.pageName = nil;
    self.channel = nil;
    self.contentType = nil;
    self.siteId = nil;
    self.subSection1 = nil;
    self.subSection2 = nil;
    self.subSection3 = nil;
    self.templateType = nil;
    self.additionalContext = nil;
    self.adapters = nil;
}
// this must be visible to the category!

// this must be visible to the category!
- (NSDictionary *)asContextData {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // then overlay page specific analytic data on top of it...
    [dict setObject:[self analyticsPageName] forKey:REIAnalyticsPageNameKey];
    [dict setObject:[self analyticsChannel] forKey:REIAnalyticsChannelKey];
    [dict setObject:[self analyticsSubSection1] forKey:REIAnalyticsSubSection1Key];
    [dict setObject:[self analyticsSubSection2] forKey:REIAnalyticsSubSection2Key];
    [dict setObject:[self analyticsSubSection3] forKey:REIAnalyticsSubSection3Key];
    [dict setObject:[self analyticsTemplateType] forKey:REIAnalyticsTemplateTypeKey];
    [dict setObject:[self analyticsSiteId] forKey:REIAnalyticsSiteIdKey];
    [dict setObject:[self analyticsContentType] forKey:REIAnalyticsContentTypeKey];
    
    if ([self analyticsProductsString].length > 0) {
        [dict setObject:[self analyticsProductsString] forKey:@"&&products"];
    }
    
    if ([self analyticsAdditionalContext].count > 0) {
        [dict addEntriesFromDictionary:[self analyticsAdditionalContext]];
    }
    
    return dict;
}
// this must be visible to the category!


- (void)configureContextData {
    NSDictionary *contextData = [[REIAnalyticsConfigurationLoader shared] contextDataForClass:self.hostingClassName];
    
    if (contextData) {
        self.additionalContext = [[NSMutableDictionary alloc] initWithDictionary:contextData];
    }
}


- (void)configureAdapters {
    self.adapters = [[NSMutableArray alloc] init];
    
    // load global adapters for config file
    for (id globalAdapter in [REIAnalyticsKitHelper shared].globalAnalyticsAdapters) {
        [self.adapters addObject:globalAdapter];
    }
    
    // load adapters specifically for this class
    NSArray *classAdapters = [[REIAnalyticsConfigurationLoader shared] adaptersForClass:self.hostingClassName];
    
    for (id adapterName in classAdapters) {
        NSObject *classAdapter = [REIObjectFactory createInstance:adapterName];
        [self.adapters addObject:classAdapter];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.trackState == TrackStateOnLoad) {
        [self handleEvent:[self analyticsPageName] contextData:[self asContextData]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.trackState == TrackStateOnAppear) {
        NSDictionary *contextData = [self asContextData];
        [self handleEvent:[self analyticsPageName] contextData:contextData];
    }
}

-(void) handleEvent:(NSString *)eventName contextData:(NSDictionary *)contextData {
    __weak REIAnalyticsViewController *weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        [weakSelf notifyAdaptersOfEvent:eventName contextData:contextData];
    });
}

-(void) notifyAdaptersOfEvent:(NSString *)eventName contextData:(NSDictionary *)contextData {
    
    NSDictionary *aggregatedAnalyticsData = [[REIAnalyticsKitHelper shared] aggregateGlobalDataWithContextData:contextData];
    
    for (id adapter in self.adapters) {
        
        if ([adapter isKindOfClass:REIAdobeAnalyticsAdapter.class]) {
            REIAdobeAnalyticsAdapter *adobeAnalyticsAdapter = (REIAdobeAnalyticsAdapter *)adapter;
            adobeAnalyticsAdapter.analyticsPageName = [self analyticsPageName];
        }
        
        [adapter handleEvent:eventName withContextData:aggregatedAnalyticsData];
    }
}

- (void)deferTrack {
    self.trackState = TrackStateDefer;
}

@end
