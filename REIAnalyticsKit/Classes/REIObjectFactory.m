//
//  ObjectFactory.m
//  Forest
//
//  Created by Chris Shreve on 4/6/16.
//  Copyright © 2016 REI. All rights reserved.
//

#import "REIObjectFactory.h"

@implementation REIObjectFactory

+ (Class)getClass:(NSString *)className;
{
    Class aClass = NSClassFromString(className);
    return aClass;
}

+ (id)createInstance:(NSString *)className
{
    Class aClass = NSClassFromString(className);
    if (!aClass) {
        aClass = [REIObjectFactory swiftClassFromString:(className)];
    }
    id object = [[aClass alloc] init];
    return object;
}

+ (Class)swiftClassFromString:(NSString *)className {
    NSString *appName = @"REI";
    NSString *classStringName = [NSString stringWithFormat:@"%@.%@", appName, className];
    return NSClassFromString(classStringName);
}

@end
