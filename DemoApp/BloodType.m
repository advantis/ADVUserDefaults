//
//  Copyright © 2012 Yuri Kotov
//


#import "BloodType.h"

NSString * BloodTypeName(BloodType type)
{
    switch (type)
    {
        case BloodTypeA:
            return @"A";
        case BloodTypeB:
            return @"B";
        case BloodTypeAB:
            return @"AB";
        case BloodTypeO:
            return @"O";
        default:
            return nil;
    }
}