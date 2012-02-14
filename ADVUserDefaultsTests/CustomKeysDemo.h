//
//  Copyright © 2012 Yuri Kotov
//


#import "ADVUserDefaults.h"

@interface CustomKeysDemo : ADVUserDefaults

@property (nonatomic) float opacity;
@property (nonatomic, getter=isHidden) BOOL hidden;

@end