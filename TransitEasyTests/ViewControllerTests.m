//
//  ViewControllerTests.m
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/28/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;


@end

@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
    self.vc = [[ViewController alloc]init];

}

- (void)tearDown {
    [super tearDown];
}



@end
