//
//  Copyright © 2012 Yuri Kotov
//


#import "BaseTest.h"

NSString * const kUselessDescription = @"Value mismatch";

@implementation BaseTest
{
	NSDictionary *_appDomain;
}

#pragma mark - SenTestCase
- (void) setUp
{
	[super setUp];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *appDomainName = [[NSBundle mainBundle] bundleIdentifier];
	_appDomain = [defaults persistentDomainForName:appDomainName];
	[defaults removePersistentDomainForName:appDomainName];
}

- (void) tearDown
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *appDomainName = [[NSBundle mainBundle] bundleIdentifier];
	[defaults setPersistentDomain:_appDomain forName:appDomainName];
	_appDomain = nil;

	[super tearDown];
}

@end
