//
//  Station.m
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/12/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "Station.h"

@implementation Station

bool serverAvailable = false;

+ (id)sharedInstance {
    static Station *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            
        }
    }
    return sharedInstance;
}

#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    _lastLocation = locations.lastObject;
    NSLog(@"Location: %F %F", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude);
    [_locationManager stopUpdatingLocation];
    NSLog(@"Turning off location monitoring");
    
}

- (void)turnOnLocationMonitoring {
    NSLog(@"Turned on");
    [_locationManager startUpdatingLocation];
}

- (void)prepareLocationMonitoring {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways: {
                [self turnOnLocationMonitoring];
                NSLog(@"Location monitoring on");
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse: {
                [self turnOnLocationMonitoring];
                NSLog(@"Turning on Location monitoring");
                break;
            }
            case kCLAuthorizationStatusDenied: {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied" message:@"You turned of location access" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                [alert show];
                break;
            }
            case kCLAuthorizationStatusNotDetermined: {
                if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [_locationManager requestWhenInUseAuthorization];
                }
                break;
            }
            default:
                break;
        }
    } else {

    }
}


- (void)getData {
    NSLog(@"Getting Data 1");
    _hostName = @"mobile-metro.herokuapp.com/";

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/?user_latitude=%f&user_longitude=%f", _hostName, _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude]];
    NSLog(@"--> %f", _lastLocation.coordinate.latitude);
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Getting Data 2");
        NSError *jsonError = nil;
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSLog(@"Json: %@",json);
        _resultsDictionary = [(NSDictionary *) json objectForKey:@"location"];
        _stationArray = [(NSDictionary *) _resultsDictionary objectForKey:@"stations"];
        _bikeShareArray = [(NSDictionary *) _resultsDictionary objectForKey:@"bikeshares"];
        NSLog(@"Getting Data 3");
        for (NSDictionary *resultsString in _stationArray) {
            NSString *remoteName = [resultsString objectForKey:@"station_name"];
            NSLog(@"station namePPPPOPOPOPOOPO: %@", remoteName);
        }
        for (NSDictionary *bikeAvail in _bikeShareArray) {
            _bikeAvailDictionary = [(NSDictionary *) bikeAvail objectForKey:@"availability"];
            NSLog(@"bike %@",_bikeAvailDictionary);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultsDoneNotification" object:nil];
        
    }];
    
}


@end
