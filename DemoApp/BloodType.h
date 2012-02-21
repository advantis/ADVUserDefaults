//
//  Copyright © 2012 Yuri Kotov
//


#import <Foundation/Foundation.h>

typedef enum
{
    BloodTypeA = 0,
    BloodTypeB,
    BloodTypeAB,
    BloodTypeO
}
BloodType;

extern NSString * BloodTypeName(BloodType type);