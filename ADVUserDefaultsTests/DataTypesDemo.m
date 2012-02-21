//
//  Copyright © 2012 Yuri Kotov
//

#import "DataTypesDemo.h"

static NSString * const kColorValueKey = @"ColorValue";

@implementation DataTypesDemo

@dynamic unsignedIntegerValue;
@dynamic integerValue;
@dynamic enumValue;
@dynamic boolValue;

@dynamic dictionaryValue;
@dynamic arrayValue;
@dynamic dateValue;
@dynamic numberValue;
@dynamic stringValue;
@dynamic dataValue;
@dynamic unsignedLongLongValue;
@dynamic unsignedLongValue;
@dynamic unsignedIntValue;
@dynamic unsignedShortValue;
@dynamic unsignedCharValue;
@dynamic doubleValue;
@dynamic floatValue;
@dynamic longLongValue;
@dynamic longValue;
@dynamic intValue;
@dynamic shortValue;
@dynamic charValue;

- (UIColor *) colorValue
{
    NSData *data = [_defaults dataForKey:kColorValueKey];
    return data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
}

- (void) setColorValue:(UIColor *)color
{
    if (color)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
        [_defaults setObject:data forKey:kColorValueKey];
    }
    else
    {
        [_defaults removeObjectForKey:kColorValueKey];
    }
}

@end
