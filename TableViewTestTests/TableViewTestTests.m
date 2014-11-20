//
//  TableViewTestTests.m
//  TableViewTestTests
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Dao.h"
#import "RowObject.h"

@interface TableViewTestTests : XCTestCase

@end

@implementation TableViewTestTests {
    Dao *dao;
}

- (void) setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    dao = [Dao sharedDao];
    [dao deleteAll];

}

- (void) tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [dao deleteAll];

}

- (void) testDaoInsertandSelect {
    // This is an example of a functional test case.
    RowObject *rowObject = [[RowObject alloc] init];
    rowObject.id = @123;
    NSDictionary *jsonDic = @{@"id" : @123};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    rowObject.jsonString = jsonString;
    rowObject.insert_time = nil;
    [dao insert:rowObject.id andJson:jsonDic];
    NSArray *resultArray = [NSArray arrayWithArray:[dao selectAll]];
    XCTAssertEqualObjects([resultArray[0] jsonString], rowObject.jsonString);

}

- (void) testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
