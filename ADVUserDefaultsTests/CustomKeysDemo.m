//
//  Copyright © 2012 Yuri Kotov
//


#import "CustomKeysDemo.h"

@implementation CustomKeysDemo

@dynamic hidden;
@dynamic opacity;

#pragma mark - ADVUserDefaults
+ (NSString *)defaultsKeyForPropertyNamed:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"CK%@", [propertyName capitalizedString]];
}

@end