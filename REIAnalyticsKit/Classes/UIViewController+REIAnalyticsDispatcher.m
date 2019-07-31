//
//  UIViewController+ShopAnalytics.m
//  REI
//
//  Created by chris1 on 7/24/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "UIViewController+REIAnalyticsDispatcher.h"
#import "REIAnalyticsViewController.h"

@implementation UIViewController (REIAnalyticsDispatcher)

// initialization
- (void)configureAnalytics {
    if ([self analyticsViewController] == nil) {
        NSString *className = [[NSStringFromClass(self.class) componentsSeparatedByString:@"."] lastObject];
        REIAnalyticsViewController *analyticsViewController = [[REIAnalyticsViewController alloc] initWithHostingClassName:className];
        
        // trigger lifecycle
        [self addChildViewController:analyticsViewController];
        [analyticsViewController didMoveToParentViewController:self];
        [self.view addSubview:analyticsViewController.view];
    }
}

- (void)clearAnalytics {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [analyticsVC removeAnalytics];
    }
}


// data write
- (void)setAnalyticsChannel:(NSString * _Nonnull)channel {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.channel = channel;
    }
}

- (void)setAnalyticsPageName:(NSString * _Nonnull)pageName {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.pageName = pageName;
    }
}

- (void)setAnalyticsParameter:(NSString *)key value:(NSString *)value {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        if (!analyticsVC.additionalContext) {
            analyticsVC.additionalContext = [[NSMutableDictionary alloc] init];
        }
        
        analyticsVC.additionalContext[key] = value;
    }
}

- (void)setAnalyticsSubSection1:(NSString * _Nonnull)subSection1 {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.subSection1 = subSection1;
    }
}

- (void)setAnalyticsSubSection2:(NSString * _Nonnull)subSection2 {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.subSection2 = subSection2;
    }
}

- (void)setAnalyticsProductString:(NSString * _Nonnull)productString {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.productsString = productString;
    }
}

- (void)setAnalyticsTemplateType:(NSString * _Nonnull)templateType {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.templateType = templateType;
    }
}

- (void)setAdditionalAnalyticsContextData:(NSDictionary<NSString *,NSString *> * _Nonnull)contextData {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        analyticsVC.additionalContext = [[NSMutableDictionary alloc] initWithDictionary:contextData];
    }
}

- (void)updateAnalyticsWithDictionary:(NSDictionary<NSString *,NSString *> * _Nonnull)dictionary {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [analyticsVC updateWithDictionary:dictionary];
    }
}


// data read
- (NSDictionary *)getAnalyticsContextData {
    NSDictionary *contextData = nil;
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        contextData = [analyticsVC asContextData];
    }
    return contextData;
}

- (NSString *)getAnalyticsPageName {
    NSString *pageName = nil;
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        pageName = analyticsVC.pageName;
    }
    return pageName;
}


// control
- (void)deferTrackState {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [analyticsVC deferTrack];
    }
}


// dispatching
- (void)dispatchAnalyticsEvent {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [self dispatchAnalyticsEvent:[analyticsVC analyticsPageName] contextData:[analyticsVC asContextData]];
    }
}


- (void)dispatchAnalyticsEvent:(NSString * _Nonnull)eventName {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [self dispatchAnalyticsEvent:eventName contextData:[analyticsVC asContextData]];
    }
}

- (void)dispatchAnalyticsEvent:(NSString * _Nonnull)eventName contextData:(NSDictionary * _Nullable)contextData {
    REIAnalyticsViewController *analyticsVC = [self analyticsViewController];
    if (analyticsVC != nil) {
        [analyticsVC handleEvent:eventName contextData:contextData];
    }
}


















// implementation
- (REIAnalyticsViewController *)analyticsViewController {
    
    REIAnalyticsViewController *foundController = nil;
    
    for (id viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:REIAnalyticsViewController.class]) {
            foundController = (REIAnalyticsViewController *)viewController;
        }
    }
    
    return foundController;
}


@end
