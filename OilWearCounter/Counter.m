//
//  Counter.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "Counter.h"

@implementation Counter
- (instancetype)initWithOil_id:(NSInteger)oil_id oil_date:(NSString*)oil_date oil_lcb:(NSInteger)oil_lcb oil_jyl:(CGFloat)oil_jyl oil_takermb:(CGFloat)tabermb oil_danjia:(CGFloat)oil_danjia oil_type:(int)oil_type oil_isfull:(BOOL)oil_isfull oil_station:(NSString *)oil_station oil_note:(NSString *)oil_note
{
    self = [super init];
    if (self) {
        self.oil_id = oil_id;
        self.oil_date = oil_date;
        self.oil_lcb = oil_lcb;
        self.oil_jyl = oil_jyl;
        self.oil_takermb = tabermb;
        self.danJia = oil_danjia;
        self.oil_type = oil_type;
        self.oil_isFull = oil_isfull;
        self.oil_station = oil_station;
        self.oil_note = oil_note;
    }
    return self;
}
@end
