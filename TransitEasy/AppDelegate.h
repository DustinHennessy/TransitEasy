//
//  AppDelegate.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Station *stationManager;


@end

