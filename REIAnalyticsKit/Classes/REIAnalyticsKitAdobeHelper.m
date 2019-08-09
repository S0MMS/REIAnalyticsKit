//
//  REIAnalyticsHelper.m
//  REI iPad
//
//  Created by Mark Wells on 5/25/14.
//  Copyright (c) 2014 Deloitte Digital. All rights reserved.
//

#import "REIAnalyticsKitAdobeHelper.h"

#import "ACPCore.h"
#import "ACPTarget.h"
#import "ACPTargetRequestObject.h"
#import "ACPAnalytics.h"
#import "ACPIdentity.h"
#import "ACPLifecycle.h"
#import "ACPSignal.h"
#import "ACPUserProfile.h"


//// Action tracking constants
NSString * const REIAnalyticsContextPageAndActionKey = @"rei.pageAndAction";

@interface REIAnalyticsKitAdobeHelper ()
@property (nonatomic, strong) NSString *retrievedCloudId;
@property (nonatomic, strong) NSString *firstTrackingId;
@property (nonatomic, strong) NSArray<ACPMobileVisitorId *>* trackingIds;
@end

@implementation REIAnalyticsKitAdobeHelper

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[REIAnalyticsKitAdobeHelper alloc] init];
        [singleton retrieveCloudId];
        [singleton retrieveTrackingIds];
    });
    return singleton;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _retrievedCloudId = @"";
        _firstTrackingId = @"";
        _trackingIds = [[NSArray alloc] init];
    }
    
    return self;
}

#pragma mark - Track State

- (void)trackState:(NSString *)state withContextData:(NSDictionary *)contextData
{
    [ACPCore trackState:state data:contextData];
}


#pragma mark - Track Action

- (void)trackAction:(NSString *)action withContextData:(NSDictionary *)contextData
{
    NSMutableDictionary *data = [@{ REIAnalyticsContextPageAndActionKey : action } mutableCopy];
    if (contextData) {
        [data addEntriesFromDictionary:contextData];
    }

    [ACPCore trackAction:action data:data];
}

- (void)configureAdobeAnalytics: (NSString *)adobeApplicationId {
    
#if DEBUG
    [ACPCore setLogLevel:ACPMobileLogLevelVerbose];
#else
    [ACPCore setLogLevel:ACPMobileLogLevelError];
#endif
    
    // FULL TILT
    [ACPTarget registerExtension];
    [ACPAnalytics registerExtension];
    [ACPIdentity registerExtension];
    [ACPLifecycle registerExtension];
    [ACPSignal registerExtension];
    [ACPUserProfile registerExtension];
    [ACPCore start:^{
        [ACPCore lifecycleStart:nil];
        [self retrieveCloudId];
        [self retrieveTrackingIds];
    }];
    
}

- (void)retrieveCloudId {
    [ACPIdentity getExperienceCloudId:^(NSString * _Nullable retrievedCloudId) {
        self.retrievedCloudId = retrievedCloudId;
    }];
}

- (void)retrieveTrackingIds {
    [ACPIdentity getIdentifiers:^(NSArray<ACPMobileVisitorId *> * _Nullable retrievedVisitorIds) {
        self.trackingIds = retrievedVisitorIds;
        if (self.trackingIds && [self.trackingIds count] > 0) {
            self.firstTrackingId = [self.trackingIds firstObject].identifier;
        }
    }];
}

- (void)setAdobeAnalyticsAppGroup:(NSString *)appGroup {
    [ACPCore setAppGroup:appGroup];
}

// will be empty until call to adobe gets back
- (NSString*)cloudMarketingId {
    return self.retrievedCloudId;
}
// will be empty until call to adobe gets back
- (NSString *)firstTrackingIdentifier {
    return self.firstTrackingId;
}

 // will be empty until call to adobe gets back
- (NSArray *)trackingIdentifiers {
    return self.trackingIds;
}

- (void)testWithName:(nullable NSString *)name
      defaultContent:(nullable NSString *)defaultContent
          parameters:(nullable NSDictionary *)parameters
            callback:(nullable void (^)(NSString* __nullable content))callback {

    // create param object
    ACPTargetParameters *params = [ACPTargetParameters targetParametersWithParameters:parameters
                                                                     profileParameters:nil
                                                                               product:nil
                                                                                 order:nil];
    // create request object
    ACPTargetRequestObject *request1 = [ACPTargetRequestObject targetRequestObjectWithName:name
                                                                          targetParameters:params
                                                                            defaultContent:defaultContent
                                                                                  callback:callback];
    // create request object array
    NSArray *requestArray = @[request1];

    // create global params object
    ACPTargetParameters *targetParameters = [ACPTargetParameters targetParametersWithParameters:nil
                                                                              profileParameters:nil
                                                                                        product:nil
                                                                                          order:nil];
    // call the api
    [ACPTarget retrieveLocationContent:requestArray withParameters:targetParameters];
    
}


@end

