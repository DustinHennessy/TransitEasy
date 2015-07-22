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
#import "AppDelegate.h"
#import "UIColor+Metro.h"

@interface ViewController ()

@property (nonatomic, strong) NSString                    *hostName;
@property (nonatomic, strong) NSMutableDictionary         *resultsDictionary;
@property (nonatomic, strong) NSMutableArray              *stationArray;
@property (nonatomic, strong) IBOutlet UITableView        *resultsTableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *bikesegmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView        *bikeShareImage;
@property (nonatomic, strong) IBOutlet UIImageView        *metroImage;
@property (nonatomic, strong) IBOutlet UIButton           *metroMapButton;
@property (nonatomic, strong) NSMutableDictionary         *bikesAvailDictionary;
@property (nonatomic, strong) NSArray                     *bikesAvailArray;
@property (nonatomic, strong) Station                     *stationManager;
@property (nonatomic, strong) AppDelegate                 *appDelegate;




@end

@implementation ViewController

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_bikesegmentedControl.selectedSegmentIndex == 0) {
//        return _stationArray.count;
        return [[_stationManager bikeShareArray] count];
    } else {
        return [[_stationManager stationArray] count];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    NSString *cellIdentifier = @"Cell";
    ScheduleTableViewCell *cell = (ScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (_bikesegmentedControl.selectedSegmentIndex == 0) {
        NSDictionary *currentBikeShare = [[_stationManager bikeShareArray] objectAtIndex:indexPath.row];
        cell.locationLabel.text = [currentBikeShare objectForKey:@"bikeshare_name"];
        NSDictionary *availabilityDict = [(NSDictionary *) currentBikeShare objectForKey:@"availability"];
        cell.availBikesLabel.text = [NSString stringWithFormat:@"%i", [[availabilityDict objectForKey:@"bikes_available"] intValue]];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"(Y) %@", [[_bikesAvailArray objectAtIndex:indexPath.row] objectForKey:@"bikes_available"]);
        
        _bikeShareImage.hidden = false;
        _metroImage.hidden = true;
        _metroMapButton.hidden = true;
        
        NSLog(@"Bike share location: %@", [[[_stationManager bikeShareArray] objectAtIndex:indexPath.row] objectForKey:@"Name"]);
        return cell;
    } else  {
        
        _bikeShareImage.hidden = true;
        _metroImage.hidden = false;
        _metroMapButton. hidden = false;
        
        NSLog(@"Metro cell else getting called");
        NSString *cellIdentifier = @"MetroCell";
        ScheduleTableViewCell *metroCell = (ScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        metroCell.stationNameLabel.text = [[[_stationManager stationArray] objectAtIndex:indexPath.row] objectForKey:@"station_name"];
        NSLog(@"ZZZZZZZZZZ %@", [[_stationArray objectAtIndex:indexPath.row] objectForKey:@"station_name"]);
        metroCell.lineTypeLabel.text = [[[_stationManager stationArray] objectAtIndex:indexPath.row] objectForKey:@"line_1"];
        metroCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"Station Address: %@", metroCell.stationAddressLabel.text);
        
        if ([metroCell.lineTypeLabel.text  isEqual: @"BL"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroBlueColor]];
        } else if ([metroCell.lineTypeLabel.text  isEqual: @"OR"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroOrangeColor]];
        } else if ([metroCell.lineTypeLabel.text  isEqual: @"GR"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroGreenColor]];
        } else if ([metroCell.lineTypeLabel.text isEqual:@"RD"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroRedColor]];
        } else if ([metroCell.lineTypeLabel.text isEqual:@"SV"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroSilverColor]];
        } else if ([metroCell.lineTypeLabel.text isEqual:@"YW"]) {
            [metroCell.lineTypeLabel setBackgroundColor:[UIColor metroYellowColor]];
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
        NSDictionary *currentStation = [[_stationManager stationArray] objectAtIndex:indexPath.row];
        destController.stationDictionary = currentStation;
    }
}



//
//- (void)getData {
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/?user_latitude=%f&user_longitude=%f", _hostName, _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude]];
//    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//    
//    [NSURLConnection sendAsynchronousRequest:urlReq queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (([data length] > 0) && (error == nil)) {
//            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"Got data: %@", dataString);
//        }
//        NSError *jsonError = nil;
//        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
//        _resultsDictionary = [(NSDictionary *) json objectForKey:@"location"];
//        _stationResultsArray = [(NSDictionary *) _resultsDictionary objectForKey:@"stations"];
//        _bikeShareArray = [(NSDictionary *) _resultsDictionary objectForKey:@"bikeshares"];
//        _bikesAvailDictionary = [(NSDictionary *) json objectForKey:@"availability"];
//        _bikesAvailArray = [(NSDictionary *) _bikesAvailDictionary objectForKey:@"bikes_available"];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_resultsTableView reloadData];
//        });
////        if (_stationResultsArray.count > 0) {
//            for (NSDictionary *resultsString in _stationResultsArray) {
//                NSString *remoteName = [resultsString objectForKey:@"station_name"];
//                NSLog(@"station namePPPPOPOPOPOOPO: %@", remoteName);
////            }
////            
//        }
//        
//    }];
//    
//}


- (IBAction)buttonTapped:(id)sender {
    

    [_stationManager getData];
    [_resultsTableView reloadData];
    
    
}

- (void)didReceiveData {
    [_resultsTableView reloadData];
}


#pragma mark - Segmented Control


- (IBAction)segmentedCtrlButtonClicked:(id)sender {
    
     [_resultsTableView reloadData];
}



#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Did load");
    NSLog(@"setup monitoring called");
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hostName = @"mobile-metro.herokuapp.com";
    _metroImage.hidden = true;
    _metroMapButton.hidden = true;
    _stationManager = _appDelegate.stationManager;
    NSLog(@"Count:%li",_bikesAvailArray.count);
    [_stationManager prepareLocationMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData) name:@"ResultsDoneNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
