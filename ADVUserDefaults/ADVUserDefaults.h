//
//  Copyright © 2012 Yuri Kotov
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/advantis/ADVUserDefaults
//

#import <Foundation/Foundation.h>

/**
* Abstract superclass for user defaults model classes.
* Automatically generates accessor methods for any declared dynamic properties.
*/
NS_REQUIRES_PROPERTY_DEFINITIONS
@interface ADVUserDefaults : NSObject

/**
* Provides access to underlying NSUserDefaults object
*
* @return Underlying NSUserDefaults object
*/
@property (readonly, nonatomic) NSUserDefaults *defaults;

/**
* Designated initializer
*
* @param defaults A NSUserDefaults object (must not be nil)
*
* @return An initialized ADVUserDefaults object
*/
- (instancetype) initWithUserDefaults:(NSUserDefaults *)defaults NS_DESIGNATED_INITIALIZER __attribute__((nonnull (1)));

/**
* Is used to dynamically generate appropriate property accessors on class initialization
*
* @warning If you override this method, please make sure that you invoke a 'super' implementation
*/
+ (void) initialize NS_REQUIRES_SUPER;

/**
* Defines how properties are mapped to NSUserDefaults keys.
* Default implementation uses the following pattern: <class_name>.<property_name>.
* You can override this method to provide your own mapping.
*
* @param propertyName Name of a property
*
* @return NSUserDefaults key to store a value for a given property
*/
+ (NSString *) defaultsKeyForPropertyNamed:(NSString *)propertyName;

@end
