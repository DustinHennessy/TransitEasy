//
//  Station.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/12/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface Station : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray    *stationArray;
@property (nonatomic, strong) NSDictionary      *resultsDictionary;
@property (nonatomic, strong) NSMutableArray    *bikeShareArray;
@property (nonatomic, strong) NSMutableArray    *bikeAvailDictionary;
@property (nonatomic, strong) NSMutableArray    *bikesAvailArray;
@property (nonatomic, strong) NSString          *stationName;
@property (nonatomic, strong) NSString          *line1;
@property (nonatomic, strong) NSString          *line2;
@property (nonatomic, strong) NSString          *trainDirection;
@property (nonatomic, strong) NSString          *timeToArrival;
@property (nonatomic, strong) NSString          *hostName;
@property (nonatomic, strong) CLLocation        *lastLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

+ (id)sharedInstance;
- (void)prepareLocationMonitoring;
- (void)getData;


@end
