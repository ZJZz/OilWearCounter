//
//  CounterDatabase.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "CounterDatabase.h"

static CounterDatabase *counterDatabase;

@implementation CounterDatabase

- (instancetype)init
{
    
    if (counterDatabase) {
        return counterDatabase;
    }
    self = [super init];
    if (self) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *databasePath = [documentsPath stringByAppendingPathComponent:@"counter.db"];
        NSLog(@"%@",databasePath);
        if (sqlite3_open([databasePath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"打开数据库文件失败!");
        }
        
    }
    counterDatabase = self;
    return counterDatabase;
}
//以单例模式返回数据源对象
+(CounterDatabase *)counterDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        counterDatabase = [[CounterDatabase alloc]init];
    });
    return counterDatabase;
}

//返回初始密码(表1)
-(NSString *)tablePassWord{
    NSString *string = [[NSString alloc]init];
    NSString *sqlString = @"select *from table_settings ";
    //sql语句被解析后的结果
    sqlite3_stmt *counterStmt;
    //调用API来获取密码信息
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &counterStmt, nil) == SQLITE_OK) {
        while (sqlite3_step(counterStmt) == SQLITE_ROW) {
            string = [NSString stringWithUTF8String:(char *)sqlite3_column_text(counterStmt, 0)];
        }
    }else{
        NSLog(@"解析失败");
    }
    sqlite3_finalize(counterStmt);
    
    
    return [string copy];
}

//返回数据库中的数据.
-(NSArray *)tableOil{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:10];
   // NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    //[dateFormatter setDateFormat:@"YYYY-MM-DD"];
    NSString *sqlString = @"select *from table_oil order by oil_lcb desc";
    sqlite3_stmt *counterStmt;
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &counterStmt, nil) == SQLITE_OK) {
        while (sqlite3_step(counterStmt) == SQLITE_ROW) {
            NSLog(@"@@@@@@@@");
            NSInteger oil_id = sqlite3_column_int(counterStmt, 0);
            NSString *date = [NSString stringWithUTF8String:(char*)sqlite3_column_text(counterStmt, 1)];
            NSInteger oil_lcb = sqlite3_column_int(counterStmt, 2);
            CGFloat oil_jyl = sqlite3_column_double(counterStmt, 3);
            CGFloat oil_takermb = sqlite3_column_double(counterStmt, 4);
            CGFloat danJia = sqlite3_column_double(counterStmt, 5);
            int oil_type = sqlite3_column_int(counterStmt, 6);
            BOOL oil_isFull = sqlite3_column_int(counterStmt, 7);
            NSString *oil_station = [NSString stringWithUTF8String:(char*)sqlite3_column_text(counterStmt, 8)];
            NSString *oil_note = [NSString stringWithUTF8String:(char*)sqlite3_column_text(counterStmt, 9)];
            Counter *counter = [[Counter alloc]initWithOil_id:oil_id oil_date:date oil_lcb:oil_lcb oil_jyl:oil_jyl oil_takermb:oil_takermb oil_danjia:danJia oil_type:oil_type oil_isfull:oil_isFull oil_station:oil_station oil_note:oil_note];
            [array addObject:counter];
        }
    }
    else{
        NSLog(@"解析失败!");
    }

    sqlite3_finalize(counterStmt);
    NSLog(@"返回的数组%@",array);
    return [array copy];
}

//插入函数(table_oil)
-(BOOL)insertToTableOilWith:(Counter*)counter{
    BOOL result;
    NSString *sqlString = [NSString stringWithFormat:@"insert into table_oil values(null,'%@',%d,%f,%f,%f,%d,%d,'%@','%@')",counter.oil_date,counter.oil_lcb,counter.oil_jyl,counter.oil_takermb,counter.danJia,counter.oil_type,counter.oil_isFull,counter.oil_station,counter.oil_note];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1,&statement , nil) == SQLITE_OK) {
        int stepResult = sqlite3_step(statement);
        if (stepResult == SQLITE_DONE) {
            NSLog(@"插入记录'%@'成功",counter.oil_station);
            result = YES;
        }else{
            NSLog(@"插入失败");
            NSLog(@"error:%d",stepResult);
            
        }

    }
    sqlite3_finalize(statement);
    
    return result;
}

//修改table_oil内容

-(BOOL)updateTableOilWith:(NSInteger)oil_id and:(Counter *)counter{
    BOOL result;
    NSString *sqlString = [NSString stringWithFormat:@"update  table_oil set oil_date = '%@',oil_lcb = %d,oil_jyl = %f,oil_takermb = %f,oil_danjia = %f,oil_type = %d,oil_isfull = %d,oil_station = '%@',oil_note = '%@' where oil_id = %d",counter.oil_date,counter.oil_lcb,counter.oil_jyl,counter.oil_takermb,counter.danJia,counter.oil_type,counter.oil_isFull,counter.oil_station,counter.oil_note,oil_id];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int stepResult = sqlite3_step(statement);
        if (stepResult == SQLITE_DONE) {
            NSLog(@"更新记录%d成功",oil_id);
            
        }else{
            NSLog(@"更新记录失败");
            NSLog(@"error:%d",stepResult);
        }
    }else{
        NSLog(@"解析失败了");
    }
    
    sqlite3_finalize(statement);
    return result;

}

//插入函数(table_settings)
-(BOOL)insertToTableSettingWith:(NSString*)passWord{
    BOOL result;
    NSString *sqlString = [NSString stringWithFormat:@"insert into table_settings values('%@')",passWord];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int stepResult = sqlite3_step(statement);
        if (stepResult == SQLITE_DONE) {
            NSLog(@"插入记录'%@'成功",passWord);
            result = YES;
        }else{
            NSLog(@"插入失败");
            NSLog(@"error:%d",stepResult);
            
        }

    }
    return result;
}


//删除函数
-(BOOL)deleteTableOilWith:(NSInteger)oil_id{
    BOOL result;
    NSString *sqlString =[NSString stringWithFormat: @"delete from table_oil where oil_id = %d",oil_id];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"删除%d成功",oil_id);
            return YES;
        }
    }
    
    sqlite3_finalize(statement);

    
    return result;
}
@end
