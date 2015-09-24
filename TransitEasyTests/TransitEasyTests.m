//
//  TransitEasyTests.m
//  TransitEasyTests
//
//  Created by Dustin Hennessy on 6/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface TransitEasyTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation TransitEasyTests

- (void)setUp {
    [super setUp];
    self.vc = [[ViewController alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testThatViewConformsToUITableViewDataSource {
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource)], @"View doesn't conform to Data Source protocol");
}

//- (void)testTableViewCellCreateCellsWithReuseIdentifier
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *cell = [self.vc tableView:self.vc.resultsTableView cellForRowAtIndexPath:indexPath];
//    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
//    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
//}


@end
