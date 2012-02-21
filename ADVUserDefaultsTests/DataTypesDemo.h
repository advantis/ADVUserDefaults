//
//  Copyright © 2012 Yuri Kotov
//


#import "ADVUserDefaults.h"

typedef enum
{
    ValueOne = -1,
    ValueTwo,
    ValueThree
}
EnumType;

@interface DataTypesDemo : ADVUserDefaults

// Main
@property (nonatomic) char charValue;
@property (nonatomic) short shortValue;
@property (nonatomic) int intValue;
@property (nonatomic) long longValue;
@property (nonatomic) long long longLongValue;
@property (nonatomic) float floatValue;
@property (nonatomic) double doubleValue;
@property (nonatomic) unsigned char unsignedCharValue;
@property (nonatomic) unsigned short unsignedShortValue;
@property (nonatomic) unsigned int unsignedIntValue;
@property (nonatomic) unsigned long unsignedLongValue;
@property (nonatomic) unsigned long long unsignedLongLongValue;
@property (nonatomic, copy) NSData *dataValue;
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSNumber *numberValue;
@property (nonatomic, copy) NSDate *dateValue;
@property (nonatomic, copy) NSArray *arrayValue;
@property (nonatomic, copy) NSDictionary *dictionaryValue;

// Additional
@property (nonatomic) BOOL boolValue;
@property (nonatomic) EnumType enumValue;
@property (nonatomic) NSInteger integerValue;
@property (nonatomic) NSUInteger unsignedIntegerValue;

// Manual
@property (nonatomic, strong) UIColor *colorValue;

@end
