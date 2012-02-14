//
//  Copyright © 2012 Yuri Kotov
//


#import "ADVUserDefaults.h"

@interface CustomAccessorsDemo : ADVUserDefaults

@property (nonatomic, getter=isCustomGetter) BOOL customGetter;
@property (nonatomic, copy, setter=specifyCustomSetter:) NSString *customSetter;

@end