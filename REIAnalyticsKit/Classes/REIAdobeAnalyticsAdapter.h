//
//  AdobeAnalyticsAdapter.h
//  REI
//
//  Created by Chris Shreve on 4/11/16.
//  Copyright © 2016 REI. All rights reserved.
//

@import Foundation;
#import "REIAnalyticsAdapter.h"

@interface REIAdobeAnalyticsAdapter : NSObject <REIAnalyticsAdapter>

@property (nonatomic, strong) NSString *analyticsPageName;

@end
