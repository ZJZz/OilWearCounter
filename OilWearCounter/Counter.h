//
//  Counter.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Counter : NSObject
@property(nonatomic,assign)NSInteger oil_id;
@property(nonatomic,strong)NSString *oil_date;
@property(nonatomic,assign)NSInteger oil_lcb;
@property(nonatomic,assign)CGFloat oil_jyl;
@property(nonatomic,assign)CGFloat oil_takermb;
@property(nonatomic,assign)CGFloat danJia;
@property(nonatomic,assign)int oil_type;
@property(nonatomic,assign)BOOL oil_isFull;
@property(nonatomic,copy)NSString *oil_station;
@property(nonatomic,copy)NSString *oil_note;



- (instancetype)initWithOil_id:(NSInteger)oil_id oil_date:(NSString*)oil_date oil_lcb:(NSInteger)oil_lcb oil_jyl:(CGFloat)oil_jyl oil_takermb:(CGFloat)tabermb oil_danjia:(CGFloat)oil_danjia oil_type:(int)oil_type oil_isfull:(BOOL)oil_isfull oil_station:(NSString *)oil_station oil_note:(NSString *)oil_note;

@end
