//
//  Copyright © 2012 Yuri Kotov
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/advantis/ADVUserDefaults
//


#import "ADVUserDefaults.h"
#import <objc/runtime.h>

@interface ADVUserDefaults ()

@property (nonatomic, readonly) NSUserDefaults *defaults;

+ (NSString *) defaultsKeyForSelector:(SEL)selector;

@end


static long long longLongGetter(ADVUserDefaults *self, SEL _cmd)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    return [[self.defaults objectForKey:key] longLongValue];
}

static void longLongSetter(ADVUserDefaults *self, SEL _cmd, long long value)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    NSNumber *object = [NSNumber numberWithLongLong:value];
    [self.defaults setObject:object forKey:key];
}

static float floatGetter(ADVUserDefaults *self, SEL _cmd)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    return [[self.defaults objectForKey:key] floatValue];
}

static void floatSetter(ADVUserDefaults *self, SEL _cmd, float value)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    NSNumber *object = [NSNumber numberWithFloat:value];
    [self.defaults setObject:object forKey:key];
}

static double doubleGetter(ADVUserDefaults *self, SEL _cmd)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    return [[self.defaults objectForKey:key] doubleValue];
}

static void doubleSetter(ADVUserDefaults *self, SEL _cmd, double value)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    NSNumber *object = [NSNumber numberWithDouble:value];
    [self.defaults setObject:object forKey:key];
}

static id objectGetter(ADVUserDefaults *self, SEL _cmd)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    return [self.defaults objectForKey:key];
}

static void objectSetter(ADVUserDefaults *self, SEL _cmd, id object)
{
    NSString *key = [[self class] defaultsKeyForSelector:_cmd];
    if (object)
    {
        [self.defaults setObject:object forKey:key];
    }
    else
    {
        [self.defaults removeObjectForKey:key];
    }
}

enum TypeEncodings
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

static NSMutableDictionary *keyMappings_;

@implementation ADVUserDefaults

#pragma mark - ADVUserDefaults
+ (NSString *) defaultsKeyForPropertyNamed:(char const *)propertyName
{
    return [NSString stringWithFormat:@"%@.%s", self, propertyName];
}

+ (NSString *) defaultsKeyForSelector:(SEL)selector
{
    NSString *key = nil;
    for (Class class = self; class; class = [class superclass])
    {
        NSDictionary *mapping = [keyMappings_ objectForKey:NSStringFromClass(class)];
        if (mapping)
        {
            key = [mapping objectForKey:NSStringFromSelector(selector)];
            if (key) break;
        }
    }
    return key;
}

+ (void) generateAccessorMethods
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    NSMutableDictionary *mapping = nil;
    if (0 < count && !imp_implementationWithBlock)
    {
        mapping = [[NSMutableDictionary alloc] initWithCapacity:(2 * count)];
        [keyMappings_ setObject:mapping forKey:NSStringFromClass(self)];
    }

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
        [mapping setValue:key forKey:NSStringFromSelector(getterSel)];
        [mapping setValue:key forKey:NSStringFromSelector(setterSel)];

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
            case UnsignedLongLong:

                if (imp_implementationWithBlock)
                {
                    getterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this) {
                        return [[this->_defaults objectForKey:key] longLongValue];
                    });
                    setterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this, long long value) {
                        NSNumber *object = [NSNumber numberWithLongLong:value];
                        [this->_defaults setObject:object forKey:key];
                    });
                }
                else
                {
                    getterImp = (IMP) longLongGetter;
                    setterImp = (IMP) longLongSetter;
                }
                break;

            case Float:

                if (imp_implementationWithBlock)
                {
                    getterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this) {
                        return [this->_defaults floatForKey:key];
                    });
                    setterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this, float value) {
                        [this->_defaults setFloat:value forKey:key];
                    });
                }
                else
                {
                    getterImp = (IMP) floatGetter;
                    setterImp = (IMP) floatSetter;
                }
                break;

            case Double:

                if (imp_implementationWithBlock)
                {
                    getterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this) {
                        return [this->_defaults doubleForKey:key];
                    });
                    setterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this, double value) {
                        [this->_defaults setDouble:value forKey:key];
                    });
                }
                else
                {
                    getterImp = (IMP) doubleGetter;
                    setterImp = (IMP) doubleSetter;
                }
                break;

            case Object:

                if (imp_implementationWithBlock)
                {
                    getterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this) {
                        return [this->_defaults objectForKey:key];
                    });
                    setterImp = imp_implementationWithBlock((__bridge void*) ^(ADVUserDefaults *this, id value) {
                        if (value)
                        {
                            [this->_defaults setObject:value forKey:key];
                        }
                        else
                        {
                            [this->_defaults removeObjectForKey:key];
                        }
                    });
                }
                else
                {
                    getterImp = (IMP) objectGetter;
                    setterImp = (IMP) objectSetter;
                }
                break;

            default:
                free(properties);
                [NSException raise:NSInternalInconsistencyException
                            format:@"Unsupported type of property \"%s\" in class %@", name, self];
                break;
        }

        char types[5];

        snprintf(types, 4, "%c@:", type);
        class_addMethod(self, getterSel, getterImp, types);

        snprintf(types, 5, "v@:%c", type);
        class_addMethod(self, setterSel, setterImp, types);
    }
    free(properties);
}

- (NSUserDefaults *) defaults
{
    return _defaults;
}

#pragma mark - NSObject
+ (void) initialize
{
    if ([ADVUserDefaults class] == self)
    {
        if (!imp_implementationWithBlock)
        {
            keyMappings_ = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
    }
    else
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