//
// Created by 李道政 on 14/11/6.
//

#import <Foundation/Foundation.h>

@class Shop;

@interface Dao : NSObject
- (instancetype) initWithDatabaseName:(NSString *) databaseName;

- (void) createTable;

- (void) dropTable;

- (NSArray *) selectAll;

- (void) insert:(NSNumber *) shopId andJson:(NSDictionary *) shopArray;

- (void) update:(NSNumber *) shopId andJson:(NSArray *) jsonArray;

- (void) delete:(NSNumber *) shopId;

- (void) deleteAll;
@end