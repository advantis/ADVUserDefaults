//
//  Copyright © 2012 Yuri Kotov
//


#import "DataTypesTests.h"
#import "DataTypesDemo.h"

#define TestScalarValue(property, value) \
    property = value; \
    XCTAssertTrue(value == property, kUselessDescription);

#define TestObjectValue(property, value) \
    XCTAssertNotNil(value, @"Test value is nil"); \
    property = value; \
    XCTAssertEqualObjects(property, value, kUselessDescription);

@implementation DataTypesTests
{
    DataTypesDemo *_defaults;
}

#pragma mark - DataTypesTests
- (void) testRegistrationDomain
{
    NSString *key = [DataTypesDemo defaultsKeyForPropertyNamed:@"dateValue"];
    XCTAssertNotNil(key, @"Key is nil");
    NSDate *value = [NSDate date];
    XCTAssertNotNil(value, @"Value is nil");
    NSDictionary *defaults = @{key: value};
    XCTAssertNotNil(value, @"Defaults is nil");
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    _defaults.dateValue = nil;
    XCTAssertEqualObjects(_defaults.dateValue, value, kUselessDescription);
}

#pragma mark - Scalar Data Types
- (void) testEdgeCasesForChar
{
    TestScalarValue(_defaults.charValue, CHAR_MIN);
    TestScalarValue(_defaults.charValue, CHAR_MAX);
}

- (void) testEdgeCasesForShort
{
    TestScalarValue(_defaults.shortValue, SHRT_MIN);
    TestScalarValue(_defaults.shortValue, SHRT_MAX);
}

- (void) testEdgeCasesForInt
{
    TestScalarValue(_defaults.intValue, INT_MIN);
    TestScalarValue(_defaults.intValue, INT_MAX);
}

- (void) testEdgeCasesForLong
{
    TestScalarValue(_defaults.longValue, LONG_MIN);
    TestScalarValue(_defaults.longValue, LONG_MAX);
}

- (void) testEdgeCasesForLongLong
{
    TestScalarValue(_defaults.longLongValue, LLONG_MIN);
    TestScalarValue(_defaults.longLongValue, LLONG_MAX);
}

- (void) testEdgeCasesForUnsignedChar
{
    TestScalarValue(_defaults.unsignedCharValue, 0);
    TestScalarValue(_defaults.unsignedCharValue, UCHAR_MAX);
}

- (void) testEdgeCasesForUnsignedShort
{
    TestScalarValue(_defaults.unsignedShortValue, 0);
    TestScalarValue(_defaults.unsignedShortValue, USHRT_MAX);
}

- (void) testEdgeCasesForUnsignedInt
{
    TestScalarValue(_defaults.unsignedIntValue, 0);
    TestScalarValue(_defaults.unsignedIntValue, UINT_MAX);
}

- (void) testEdgeCasesForUnsignedLong
{
    TestScalarValue(_defaults.unsignedLongValue, 0);
    TestScalarValue(_defaults.unsignedLongValue, ULONG_MAX);
}

- (void) testEdgeCasesForUnsignedLongLong
{
    TestScalarValue(_defaults.unsignedLongLongValue, 0);
    TestScalarValue(_defaults.unsignedLongLongValue, ULLONG_MAX);
}

- (void) testEdgeCasesForFloat
{
    _defaults.floatValue = FLT_MIN;
    XCTAssertEqualWithAccuracy(_defaults.floatValue, FLT_MIN, FLT_MIN, kUselessDescription);
    _defaults.floatValue = -FLT_MIN;
    XCTAssertEqualWithAccuracy(_defaults.floatValue, -FLT_MIN, FLT_MIN, kUselessDescription);
    _defaults.floatValue = FLT_MAX;
    XCTAssertEqualWithAccuracy(_defaults.floatValue, FLT_MAX, FLT_MIN, kUselessDescription);
    _defaults.floatValue = -FLT_MAX;
    XCTAssertEqualWithAccuracy(_defaults.floatValue, -FLT_MAX, FLT_MIN, kUselessDescription);
}

- (void) testEdgeCasesForDouble
{
    _defaults.doubleValue = DBL_MIN;
    XCTAssertEqualWithAccuracy(_defaults.doubleValue, DBL_MIN, DBL_MIN, kUselessDescription);
    _defaults.doubleValue = -DBL_MIN;
    XCTAssertEqualWithAccuracy(_defaults.doubleValue, -DBL_MIN, DBL_MIN, kUselessDescription);
    _defaults.doubleValue = DBL_MAX;
    XCTAssertEqualWithAccuracy(_defaults.doubleValue, DBL_MAX, DBL_MIN, kUselessDescription);
    _defaults.doubleValue = -DBL_MAX;
    XCTAssertEqualWithAccuracy(_defaults.doubleValue, -DBL_MAX, DBL_MIN, kUselessDescription);
}

#pragma mark - Object Data Types
- (void) testDataValue
{
    const unsigned char size = 4;
    UInt8 bytes[size] = {0xA, 0xB, 0xC, 0xD};
    NSData *dataValue = [NSData dataWithBytes:bytes length:size];
    TestObjectValue(_defaults.dataValue, dataValue);
}

- (void) testStringValue
{
    NSString *stringValue = @"Test string";
    TestObjectValue(_defaults.stringValue, stringValue)
}

- (void) testNumberValue
{
    NSNumber *numberValue = @42;
    TestObjectValue(_defaults.numberValue, numberValue);
}

- (void) testDateValue
{
    NSDate *dateValue = [NSDate date];
    TestObjectValue(_defaults.dateValue, dateValue);
}

- (void) testArrayValue
{
    NSArray *arrayValue = @[@"String", @YES, [NSDate date]];
    _defaults.arrayValue = arrayValue;
    XCTAssertTrue([_defaults.arrayValue isEqualToArray:arrayValue], kUselessDescription);
}

- (void) testDictionaryValue
{
    NSDictionary *dictionaryValue = @{@"Array": @[], @"Date": [NSDate date]};
    _defaults.dictionaryValue = dictionaryValue;
    XCTAssertTrue([_defaults.dictionaryValue isEqualToDictionary:dictionaryValue], kUselessDescription);
}

#pragma mark - Additional Data Types
- (void) testEdgeCasesForBool
{
    TestScalarValue(_defaults.boolValue, NO);
    TestScalarValue(_defaults.boolValue, YES);
}

- (void) testEdgeCasesForEnum
{
    TestScalarValue(_defaults.enumValue, ValueOne);
    TestScalarValue(_defaults.enumValue, ValueTwo);
    TestScalarValue(_defaults.enumValue, ValueThree);
}

- (void) testEdgeCasesForInteger
{
    TestScalarValue(_defaults.integerValue, (NSInteger) NSIntegerMin);
    TestScalarValue(_defaults.integerValue, (NSInteger) NSIntegerMax);
}

- (void) testEdgeCasesForUnsignedInteger
{
    TestScalarValue(_defaults.unsignedIntegerValue, (NSUInteger) 0);
    TestScalarValue(_defaults.unsignedIntegerValue, (NSUInteger) NSUIntegerMax);
}

- (void) testNilValue
{
    _defaults.stringValue = @"Will be replaced with nil";
    _defaults.stringValue = nil;
    XCTAssertNil(_defaults.stringValue, kUselessDescription);
}

- (void) testColorValue
{
    UIColor *color = [UIColor magentaColor];
    _defaults.colorValue = color;
    XCTAssertTrue(CGColorEqualToColor(_defaults.colorValue.CGColor, color.CGColor), kUselessDescription);
}

#pragma mark - SenTestCase
- (void) setUp
{
    [super setUp];

    _defaults = [DataTypesDemo new];
    XCTAssertNotNil(_defaults, @"Unable to create an instance of %@", [DataTypesDemo class]);
}

- (void) tearDown
{
    _defaults = nil;
    [super tearDown];
}

@end
