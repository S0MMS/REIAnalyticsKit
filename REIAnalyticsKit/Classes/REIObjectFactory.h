//
//  ObjectFactory.h
//  Forest
//
//  Created by Chris Shreve on 4/6/16.
//  Copyright © 2016 REI. All rights reserved.
//

@import Foundation;

@interface REIObjectFactory : NSObject

//+ (id)create:(NSString *)className;

+ (Class)getClass:(NSString *)className;
+ (id)createInstance:(NSString *)className;

@end
