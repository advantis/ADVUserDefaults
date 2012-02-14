//
//  Copyright © 2012 Yuri Kotov
//


#import "CustomKeysDemo.h"

@implementation CustomKeysDemo

@dynamic hidden;
@dynamic opacity;

#pragma mark - ADVUserDefaults
+ (NSString *) defaultsKeyForPropertyNamed:(char const *)propertyName
{
	return [NSString stringWithFormat:@"CK%c%s", toupper(propertyName[0]), ++propertyName];
}

@end