//
//  ViewController.m
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ScheduleTableViewCell.h"
#import "StationsTableViewCell.h"
#import "Station.h"
#import "MetroViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager           *locationManager;
@property (nonatomic, strong) AppDelegate                 *appDelegate;
@property (nonatomic, strong) CLLocation                  *lastLocation;
@property (nonatomic, strong) NSString                    *hostName;
@property (nonatomic, strong) NSMutableArray              *resultsArray;
@property (nonatomic, strong) NSMutableArray              *stationResultsArray;
@property (nonatomic, strong) IBOutlet UITableView        *resultsTableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *bikesegmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView        *bikeShareImage;
@property (nonatomic, strong) IBOutlet UIImageView        *metroImage;


@end

@implementation ViewController

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_bikesegmentedControl.selectedSegmentIndex == 0) {
        return _resultsArray.count;
    } else {
        return _stationResultsArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    ScheduleTableViewCell *cell = (ScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (_bikesegmentedControl.selectedSegmentIndex == 0) {
        cell.locationLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.availBikesLabel.text = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"nbBikes"];
        
        _bikeShareImage.hidden = false;
        _metroImage.hidden = true;
        NSLog(@"Bike share location: %@", [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"Name"]);
        return cell;
    } else  {
        
        _bikeShareImage.hidden = true;
        _metroImage.hidden = false;
        
        NSLog(@"Metro cell else getting called");
        NSString *cellIdentifier = @"MetroCell";
        ScheduleTableViewCell *metroCell = (ScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        metroCell.stationNameLabel.text = [[_stationResultsArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        metroCell.stationAddressLabel.text = [[_stationResultsArray objectAtIndex:indexPath.row] objectForKey:@"Code"];
        metroCell.lineTypeLabel.text = [[_stationResultsArray objectAtIndex:indexPath.row] objectForKey:@"LineCode1"];
        NSLog(@"Station Address: %@", metroCell.stationAddressLabel.text);
        if ([metroCell.lineTypeLabel.text  isEqual: @"BL"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor blueColor]];
        } else if ([metroCell.lineTypeLabel.text  isEqual: @"OR"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor orangeColor]];
        } else if ([metroCell.lineTypeLabel.text  isEqual: @"GR"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor greenColor]];
        }
        NSLog(@"Z%@Z", metroCell.lineTypeLabel.text);
        return metroCell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toStationDetailSegue" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MetroViewController *destController = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"toStationDetailSegue"]) {
        
        NSIndexPath *indexPath = [_resultsTableView indexPathForSelectedRow];
        Station *currentStation = [_resultsArray objectAtIndex:indexPath.row];
        destController.stations = currentStation;
    }
}


#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    _lastLocation = locations.lastObject;
    NSLog(@"Location: %F %F", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude);
    [_locationManager stopUpdatingLocation];

}

- (void)turnOnLocationMonitoring {
    NSLog(@"Turned on");
    [_locationManager startUpdatingLocation];
}

- (void)setupLocationMonitoring {
    
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied" message:@"You turned of location access" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:@"Turn on your location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}



- (void)sendData {
    NSLog(@"Lat & Long");

    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/bikeshare?latitude=%f&longitude=%f", _hostName, _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude]];
    NSLog(@"%f, %f", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:fileUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (([data length] > 0) && (error == nil)) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Got data:zzz%@zzz", dataString);
        }
        
        NSError *jsonError = nil;
        NSJSONSerialization *json =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        _resultsArray = [(NSDictionary *) json objectForKey:@"results"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_resultsTableView reloadData];
        });
        if (_resultsArray.count > 0) {
            for (NSDictionary *bikeInfoString in _resultsArray) {
                NSString *remoteFileName = [bikeInfoString objectForKey:@"name"];
                NSLog(@"rf: %@", remoteFileName);
            }
            
        }
    }];
}

- (void)sendMetroStationData {
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/stationLocation?latitude=%flongitude=%f", _hostName, _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude]];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (([data length] > 0) && (error == nil)) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Got data: %@", dataString);
        }
        NSError *jsonError = nil;
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        _stationResultsArray = [(NSDictionary *) json objectForKey:@"results"];
        dispatch_async(dispatch_get_main_queue(), ^{
        [_resultsTableView reloadData];
    });
        if (_stationResultsArray.count > 0) {
            for (NSDictionary *stationInfoString in _stationResultsArray) {
                NSString *remoteName = [stationInfoString objectForKey:@"Name"];
                NSLog(@"remote name: %@", remoteName);
                NSLog(@"Station array count: %lu", (unsigned long)_stationResultsArray.count);
                NSString *lineCode = [stationInfoString objectForKey:@"LineCode1"];
                NSLog(@"Station Line XX: %@", lineCode);
            }
        }
    }];
    
}



- (IBAction)buttonTapped:(id)sender {
    
    [self sendData];
    [self sendMetroStationData];
    
    
}


#pragma mark - Segmented Control


- (IBAction)segmentedCtrlButtonClicked:(id)sender {
    
     [_resultsTableView reloadData];
}



#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Did load");
     [self setupLocationMonitoring];
    NSLog(@"setup monitoring called");
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hostName = @"sleepy-bastion-1468.herokuapp.com/";
    _metroImage.hidden = true;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
