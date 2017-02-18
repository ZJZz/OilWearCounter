//
//  CounterDatabase.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Counter.h"

@interface CounterDatabase : NSObject
{
    sqlite3 *_database;
}
+(CounterDatabase *)counterDatabase;
-(NSString *)tablePassWord;
-(NSArray *)tableOil;
-(BOOL)insertToTableOilWith:(Counter*)counter;
-(BOOL)insertToTableSettingWith:(NSString*)passWord;
-(BOOL)deleteTableOilWith:(NSInteger)oil_id;
-(BOOL)updateTableOilWith:(NSInteger)oil_id and:(Counter *)counter;
@end
