//
//  Copyright © 2012 Yuri Kotov
//


#import "CustomKeysTests.h"
#import "CustomKeysDemo.h"

@implementation CustomKeysTests
{
    CustomKeysDemo *_defaults;
}

#pragma mark - SenTestCase
- (void) setUp
{
    [super setUp];

    _defaults = [CustomKeysDemo new];
    XCTAssertNotNil(_defaults, @"Unable to create an instance of %@", [CustomKeysDemo class]);
}

- (void) tearDown
{
    _defaults = nil;
    [super tearDown];
}

#pragma mark - CustomKeysTests
- (void) testReading
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    const float CDOpacity = 0.4f;
    [defaults setFloat:CDOpacity forKey:@"CKOpacity"];
    XCTAssertEqual(_defaults.opacity, CDOpacity, kUselessDescription);

    [defaults setBool:YES forKey:@"CKHidden"];
    XCTAssertEqual([_defaults isHidden], YES, kUselessDescription);
}

- (void) testWriting
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    const float CDOpacity = 0.3f;
    _defaults.opacity = CDOpacity;
    XCTAssertEqual([defaults floatForKey:@"CKOpacity"], CDOpacity, kUselessDescription);

    _defaults.hidden = YES;
    XCTAssertEqual([defaults boolForKey:@"CKHidden"], YES, kUselessDescription);
}

@end
