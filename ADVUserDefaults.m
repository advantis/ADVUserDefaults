//
//  Copyright © 2012 Yuri Kotov
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/advantis/ADVUserDefaults
//

#import "ADVUserDefaults.h"
#import <objc/runtime.h>

#ifndef __IPHONE_6_0
    #define BLOCK_CAST (__bridge void*)
#else
    #define BLOCK_CAST
#endif

NS_ENUM(char, TypeEncodings)
{
    Char                = 'c',
    Short               = 's',
    Int                 = 'i',
    Long                = 'l',
    LongLong            = 'q',
    UnsignedChar        = 'C',
    UnsignedShort       = 'S',
    UnsignedInt         = 'I',
    UnsignedLong        = 'L',
    UnsignedLongLong    = 'Q',
    Float               = 'f',
    Double              = 'd',
    Object              = '@'
};

@implementation ADVUserDefaults

#pragma mark - ADVUserDefaults
+ (NSString *) defaultsKeyForPropertyNamed:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"%@.%@", self, propertyName];
}

+ (void) generateAccessorMethods
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    for (int i = 0; i < count; ++i)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);

	    SEL getter;
	    char *getterName = property_copyAttributeValue(property, "G");
	    if (getterName)
	    {
			getter = sel_registerName(getterName);
		    free(getterName);
	    }
	    else
	    {
		    getter = sel_registerName(name);
	    }

	    SEL setter;
	    char *setterName = property_copyAttributeValue(property, "S");
	    if (!setterName)
        {
	        asprintf(&setterName, "set%c%s:", toupper(name[0]), name + 1);
        }
	    setter = sel_registerName(setterName);
	    free(setterName);

	    NSString *propertyName = [NSString stringWithUTF8String:name];
	    NSString *key = [self defaultsKeyForPropertyNamed:propertyName];

        IMP getterImp = NULL;
        IMP setterImp = NULL;

	    char *typeValue = property_copyAttributeValue(property, "T");
	    const char type = typeValue[0];
	    free(typeValue);
	    
        switch (type)
        {
            case Char:
            case Short:
            case Int:
            case Long:
            case LongLong:
            case UnsignedChar:
            case UnsignedShort:
            case UnsignedInt:
            case UnsignedLong:
            case UnsignedLongLong: {
	            getterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {
		            return [[this->_defaults objectForKey:key] longLongValue];
	            });
                setterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, long long value) {
	                [this->_defaults setObject:@(value) forKey:key];
                });
	            break;
            }
            case Float: {
	            getterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {
		            return [this->_defaults floatForKey:key];
	            });
                setterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, float value) {
	                [this->_defaults setFloat:value forKey:key];
                });
                break;
            }
            case Double: {
	            getterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {
		            return [this->_defaults doubleForKey:key];
	            });
                setterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, double value) {
	                [this->_defaults setDouble:value forKey:key];
                });
                break;
            }
            case Object: {
	            getterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {
		            return [this->_defaults objectForKey:key];
	            });
                setterImp = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, id value) {
	                if (value)
	                {
		                [this->_defaults setObject:value forKey:key];
	                }
	                else
	                {
		                [this->_defaults removeObjectForKey:key];
	                }
                });
                break;
            }
            default:
                free(properties);
                [NSException raise:NSInternalInconsistencyException
                            format:@"Unsupported type of property \"%s\" in class %@", name, self];
        }

        char types[5];

        snprintf(types, 4, "%c@:", type);
        class_addMethod(self, getter, getterImp, types);

        snprintf(types, 5, "v@:%c", type);
        class_addMethod(self, setter, setterImp, types);
    }
    free(properties);
}

#pragma mark - NSObject
+ (void) initialize
{
    if ([ADVUserDefaults class] != self)
    {
        [self generateAccessorMethods];
    }
}

- (id) init
{
    if ((self = [super init]))
    {
        _defaults = [NSUserDefaults new];
    }
    return self;
}

- (void) dealloc
{
    [_defaults synchronize];
    #if !__has_feature(objc_arc)
        [_defaults release];
        [super dealloc];
    #endif
}

@end