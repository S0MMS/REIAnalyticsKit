#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "REIAdobeAnalyticsAdapter.h"
#import "REIAnalyticsAdapter.h"
#import "REIAnalyticsConfigurationLoader.h"
#import "REIAnalyticsDataProvider.h"
#import "REIAnalyticsDispatcher.h"
#import "REIAnalyticsKitAdobeHelper.h"
#import "REIAnalyticsKitHelper.h"
#import "REIAnalyticsViewController.h"
#import "REICoreAnalyticsDataProvider.h"
#import "REINewRelicAnalyticsAdapter.h"
#import "REIObjectFactory.h"
#import "UIViewController+REIAnalyticsDispatcher.h"

FOUNDATION_EXPORT double REIAnalyticsKitVersionNumber;
FOUNDATION_EXPORT const unsigned char REIAnalyticsKitVersionString[];

