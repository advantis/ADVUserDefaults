//
//  Copyright © 2012 Yuri Kotov
//


#import "ADVUserDefaults.h"
#import "BloodType.h"

@interface UserDefaults : ADVUserDefaults

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSDate *birthDate;
@property (nonatomic) BloodType bloodType;
@property (nonatomic, getter=isRhesusFactorPositive) BOOL positiveRhesusFactor;
@property (nonatomic) float bloodSugar;

@end