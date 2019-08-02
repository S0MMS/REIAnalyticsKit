//
//  ShopAnalyticsConfigurationLoader.m
//  REI
//
//  Created by chris1 on 7/25/19.
//  Copyright © 2019 REI. All rights reserved.
//

#import "REIAnalyticsConfigurationLoader.h"

static NSString * const kGlobalAnalyticsProvidersKey = @"globalAnalyticsProviders";
static NSString * const kGlobalAnalyticsAdaptersKey = @"globalAnalyticsAdapters";

static NSString * const kConfigFileName = @"AnalyticsConfiguration";
static NSString * const kConfigFileType = @"json";
static NSString * const kDefaultsKey = @"defaults";
static NSString * const kContextDataKey = @"contextData";
static NSString * const kClassesKey = @"classes";
static NSString * const kAdaptersKey = @"adapters";




@interface REIAnalyticsConfigurationLoader ()

@property (nonatomic, strong) NSDictionary *configuration;

@end


@implementation REIAnalyticsConfigurationLoader

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[REIAnalyticsConfigurationLoader alloc] init];
    });
    return singleton;
}

- (NSDictionary *)configuration {
    if (!_configuration) {
        _configuration = [[NSDictionary alloc] init];

        NSString *path = [NSBundle.mainBundle pathForResource:kConfigFileName ofType:kConfigFileType];
        
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                _configuration = jsonData;
            }
        }
    }
    
    return _configuration;
}

- (NSDictionary *)globalDefaults {
    
    NSDictionary *defaultDataDictionary = nil;
    
    if (self.configuration) {
        NSDictionary *defaultData = self.configuration[kDefaultsKey];
        if (defaultData && [[defaultData allKeys] count] > 0 ) {
            defaultDataDictionary = defaultData;
        }
    }
    
    return defaultDataDictionary;
}

- (NSDictionary *)defaultContext {
    
    NSDictionary *defaultDataDictionary = nil;
    
    if (self.configuration) {
        NSDictionary *defaultData = self.configuration[kContextDataKey];
        if (defaultData && [[defaultData allKeys] count] > 0 ) {
            defaultDataDictionary = defaultData;
        }
    }
    
    return defaultDataDictionary;
}


- (NSArray *)globalAnalyticsProviders {
    return [self loadNameArray:kGlobalAnalyticsProvidersKey];
}

- (NSArray *)globalAnalyticsAdapters {
    return [self loadNameArray:kGlobalAnalyticsAdaptersKey];
}

- (NSArray *)loadNameArray:(NSString *)key {
    NSArray *array = [[NSArray alloc] init];
    
    if (self.configuration) {
        NSArray *arr = self.configuration[key];
        if (arr && [arr count] > 0 ) {
            array = arr;
        }
    }
    
    return array;
}


-(NSDictionary *)defaultsForClass:(NSString *)className {
    
    NSDictionary *data = nil;

    if (self.configuration) {
        
        NSDictionary *globalDefaults = [self globalDefaults];
        NSDictionary *classDefaults = nil;
        
        NSDictionary *classesBlock = self.configuration[kClassesKey];
        if (classesBlock) {
            NSDictionary *classData = classesBlock[className];

            if (classData) {
                classDefaults = classData[kDefaultsKey];
            }
        }
        
        // merge global and class defaults
        NSMutableDictionary *mergedDefaults = [[NSMutableDictionary alloc] initWithDictionary:globalDefaults];
        [mergedDefaults addEntriesFromDictionary:classDefaults];
        data = [[NSDictionary alloc] initWithDictionary: mergedDefaults];
                
    }

    return data;
}


- (NSDictionary *)contextDataForClass:(NSString *)className {
    
    NSDictionary *data = nil;
    
    if (self.configuration) {
        NSDictionary *classesBlock = self.configuration[kClassesKey];

        if (classesBlock) {
            NSDictionary *classData = classesBlock[className];
            
            if (classData) {
                NSDictionary *contextData = classData[kContextDataKey];
                
                if (contextData && [[contextData allKeys] count] > 0) {
                    
                    NSDictionary *defaultContext =[self defaultContext];
                    if (defaultContext) {
                        NSMutableDictionary *mergedContext = [[NSMutableDictionary alloc] initWithDictionary:defaultContext];
                        
                        for (id key in contextData) {
                            mergedContext[key] = contextData[key];
                        }
                        data = [[NSDictionary alloc] initWithDictionary: mergedContext];
                    } else {
                        data = contextData;
                    }
                    
                }
            }
        }
    }

    return data;
}

- (NSArray *)adaptersForClass:(NSString *)className {
    
    NSArray *adapters = nil;
    
    if (self.configuration) {
        NSDictionary *classesBlock = self.configuration[kClassesKey];

        if (classesBlock) {
            NSDictionary *classData = classesBlock[className];
            
            if (classData) {
                adapters = classData[kAdaptersKey];
            }
        }
    }
    
    return adapters;
}











@end
