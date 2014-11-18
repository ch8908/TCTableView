//
// Created by 李道政 on 14/11/6.
//

#import "Dao.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "RowObject.h"
#import "Shop.h"

@interface Dao()
@property (nonatomic, strong) NSArray *resultTable;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSString *table;
@end

@implementation Dao {

}

- (instancetype) initWithDatabaseName:(NSString *) databaseName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"%@",documentsDirectory);
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    _database = [FMDatabase databaseWithPath:writableDBPath];
    [_database open];
    return self;
}

- (void) createTable {
    [self.database executeUpdate:@"CREATE TABLE SHOP "
      "(identifier INTEGER  PRIMARY KEY NOT NULL,"
      "json TEXT NOT NULL,"
      "insert_time INTEGER NOT NULL)"];

}

- (NSArray *) selectAll {
    NSMutableArray *result = [NSMutableArray array];

    FMResultSet *queried = [self.database executeQuery:@"SELECT * FROM SHOP ORDER BY insert_time"];
    while ([queried next]) {
        RowObject *rowObject = [[RowObject alloc] init];
        rowObject.id = @([queried intForColumnIndex:0]);
        rowObject.jsonString = [queried stringForColumnIndex:1];
        rowObject.insert_time = @([queried intForColumnIndex:2]);
        [result addObject:rowObject];
//        NSLog(@"id %@ | json %@ | insert time %@", rowObject.id, rowObject.jsonString, rowObject.insert_time);
//        NSLog(@"id %@ | json %@ | insert time %@", [result.lastObject id], [result.lastObject jsonString], [result.lastObject insert_time]);
    }

    return result;
}

- (void) insert:(NSNumber *) shopId andJson:(NSDictionary *) shopDic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shopDic options:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSLog(@"INSERT INTO SHOP (identifier, json, insert_time) VALUES (%@, %@, %@)", shopId, jsonString, timestamp);
    [self.database executeUpdate:@"INSERT INTO SHOP (identifier, json, insert_time) VALUES (?, ?, ?)", shopId,
                                 jsonString, timestamp];

}

- (void) update:(NSNumber *) shopId andJson:(NSArray *) jsonArray {

}

- (void) delete:(NSNumber *) shopId{
    NSLog(@"Delete shop id = %@",shopId);
    [self.database executeUpdate:@"DELETE FROM SHOP WHERE identifier = ?",shopId];
}


@end