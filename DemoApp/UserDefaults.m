//
//  Copyright © 2012 Yuri Kotov
//


#import "UserDefaults.h"

@implementation UserDefaults

@dynamic bloodSugar;
@dynamic positiveRhesusFactor;
@dynamic bloodType;
@dynamic birthDate;
@dynamic fullName;

#pragma mark - NSObject
+ (void) initialize
{
    [super initialize];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Defaults" withExtension:@"plist"];
    NSDictionary *defaults = [[NSDictionary alloc] initWithContentsOfURL:url];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end