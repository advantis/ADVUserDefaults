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

static char * AttributeType     = "T";
static char * AttributeGetter   = "G";
static char * AttributeSetter   = "S";
static char * AttributeDynamic  = "D";

NS_INLINE SEL PropertyGetter(objc_property_t property)
{
    SEL getter;

    char *getterName = property_copyAttributeValue(property, AttributeGetter);
    if (getterName)
    {
        getter = sel_registerName(getterName);
        free(getterName);
    }
    else
    {
        getter = sel_registerName(property_getName(property));
    }

    return getter;
};

NS_INLINE SEL PropertySetter(objc_property_t property)
{
    SEL setter;

    char *setterName = property_copyAttributeValue(property, AttributeSetter);
    if (!setterName)
    {
        const char *propertyName = property_getName(property);
        asprintf(&setterName, "set%c%s:", toupper(propertyName[0]), propertyName + 1);
    }
    setter = sel_registerName(setterName);
    free(setterName);

    return setter;
};

NS_INLINE BOOL PropertyIsDynamic(objc_property_t property)
{
    BOOL isDynamic = NO;

    char *dynamic = property_copyAttributeValue(property, AttributeDynamic);
    if (dynamic)
    {
        isDynamic = YES;
        free(dynamic);
    }

    return isDynamic;
}

#define ScalarMapping(type, selector)                                                                       \
        @(@encode(type)) : ^(NSString *key, IMP *getter, IMP *setter) {                                     \
            *getter = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {                     \
                return [[this.defaults objectForKey:key] selector];                                         \
            });                                                                                             \
            *setter = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, type value) {         \
                [this.defaults setObject:@(value) forKey:key];                                              \
            });                                                                                             \
        }                                                                                                   \


@interface ADVUserDefaults ()
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation ADVUserDefaults

@synthesize defaults = _defaults;

#pragma mark - ADVUserDefaults
+ (NSString *) defaultsKeyForPropertyNamed:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"%@.%@", NSStringFromClass(self), propertyName];
}

+ (void) generateAccessorMethods
{
    NSDictionary *typeMapping = @{
        ScalarMapping(int, intValue),
        ScalarMapping(char, charValue),
        ScalarMapping(long, longValue),
        ScalarMapping(BOOL, boolValue),
        ScalarMapping(short, shortValue),
        ScalarMapping(float, floatValue),
        ScalarMapping(double, doubleValue),
        ScalarMapping(long long, longLongValue),
        ScalarMapping(unsigned int, unsignedIntValue),
        ScalarMapping(unsigned char, unsignedCharValue),
        ScalarMapping(unsigned long, unsignedLongValue),
        ScalarMapping(unsigned short, unsignedShortValue),
        ScalarMapping(unsigned long long, unsignedLongLongValue),
        @(@encode(id)) : ^(NSString *key, IMP *getter, IMP *setter) {
            *getter = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this) {
                return [this.defaults objectForKey:key];
            });
            *setter = imp_implementationWithBlock(BLOCK_CAST ^(ADVUserDefaults *this, id object) {
                if (object)
                {
                    [this.defaults setObject:object forKey:key];
                }
                else
                {
                    [this.defaults removeObjectForKey:key];
                }
            });
        }
    };

    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    for (unsigned int i = 0; i < count; ++i)
    {
        objc_property_t property = properties[i];

        if (!PropertyIsDynamic(property)) continue;

        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        NSString *key = [self defaultsKeyForPropertyNamed:propertyName];
        NSAssert(key, @"+[%@ %@] did return nil for property named '%@'",
            NSStringFromClass(self),
            NSStringFromSelector(@selector(defaultsKeyForPropertyNamed:)),
            propertyName);

        char *type = property_copyAttributeValue(property, AttributeType);
        char typeEncoding[2] = { type[0], '\0' };
        free(type);

        IMP getterImp = NULL;
        IMP setterImp = NULL;
        typedef void(^AccessorsGenerationBlock)(NSString *, IMP *, IMP *);
        AccessorsGenerationBlock block = typeMapping[@(typeEncoding)];
        if (block)
        {
            block(key, &getterImp, &setterImp);
        }
        else
        {
            free(properties);
            [NSException raise:NSInternalInconsistencyException
                        format:@"Unsupported type of property \"%s\" in class %@", name, self];
        }

        char types[5];

        snprintf(types, 4, "%s@:", typeEncoding);
        SEL getter = PropertyGetter(property);
        class_addMethod(self, getter, getterImp, types);

        snprintf(types, 5, "v@:%s", typeEncoding);
        SEL setter = PropertySetter(property);
        class_addMethod(self, setter, setterImp, types);
    }
    free(properties);
}

- (instancetype) initWithUserDefaults:(NSUserDefaults *)defaults
{
    NSParameterAssert(defaults);
    if ((self = [super init]))
    {
        _defaults = defaults;
    }
    return self;
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
    return [self initWithUserDefaults:[NSUserDefaults new]];
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