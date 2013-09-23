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
+ (NSString *) defaultsKeyForPropertyNamed:(char const *)propertyName
{
    return [NSString stringWithFormat:@"%@.%s", self, propertyName];
}

+ (void) generateAccessorMethods
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    for (int i = 0; i < count; ++i)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);

        char *getter = strstr(attributes, ",G");
        if (getter)
        {
            getter = strdup(getter + 2);
            getter = strsep(&getter, ",");
        }
        else
        {
            getter = strdup(name);
        }
        SEL getterSel = sel_registerName(getter);
        free(getter);

        char *setter = strstr(attributes, ",S");
        if (setter)
        {
            setter = strdup(setter + 2);
            setter = strsep(&setter, ",");
        }
        else
        {
            asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        }
        SEL setterSel = sel_registerName(setter);
        free(setter);

        NSString *key = [self defaultsKeyForPropertyNamed:name];

        IMP getterImp = NULL;
        IMP setterImp = NULL;
        char type = attributes[1];
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
        class_addMethod(self, getterSel, getterImp, types);

        snprintf(types, 5, "v@:%c", type);
        class_addMethod(self, setterSel, setterImp, types);
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
    self = [super init];
    if (self)
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