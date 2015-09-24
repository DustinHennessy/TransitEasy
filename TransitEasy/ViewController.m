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
#import "UIColor+Metro.h"
#import "STTwitter.h"
#import "TweetCollectionViewCell.h"


@interface ViewController ()

@property (nonatomic, strong) NSString                    *hostName;
@property (nonatomic, strong) NSMutableDictionary         *resultsDictionary;
@property (nonatomic, strong) NSMutableArray              *stationArray;
@property (nonatomic, strong) IBOutlet UISegmentedControl *bikesegmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView        *bikeShareImage;
@property (nonatomic, strong) IBOutlet UIImageView        *metroImage;
@property (nonatomic, strong) IBOutlet UIButton           *metroMapButton;
@property (nonatomic, strong) NSMutableDictionary         *bikesAvailDictionary;
@property (nonatomic, strong) NSArray                     *bikesAvailArray;
@property (nonatomic, strong) Station                     *stationManager;
@property (nonatomic, strong) AppDelegate                 *appDelegate;
@property (nonatomic, strong) IBOutlet UICollectionView   *tweetCollectionView;
@property (nonatomic, strong) NSMutableArray              *tweetFeedArray;


@end

@implementation ViewController


#pragma mark - Collection View Methods 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tweetFeedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tCell";
    TweetCollectionViewCell *tCell = (TweetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *twitterDict = self.tweetFeedArray[indexPath.row];
    tCell.tweetTextView.text = [twitterDict objectForKey:@"text"];
    tCell.twitterHandleLabel.text = [twitterDict objectForKey:@"screen_name"];
    return tCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(253.0, 108.0);
}



#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_bikesegmentedControl.selectedSegmentIndex == 0) {
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
        NSDictionary *stationDict = [[_stationManager stationArray] objectAtIndex:indexPath.row];
        metroCell.stationNameLabel.text = [stationDict objectForKey:@"station_name"];
        float distance = [[stationDict objectForKey:@"station_distance"] floatValue];
        metroCell.stationAddressLabel.text = [NSString stringWithFormat:@"%.1f Miles",distance];
        NSLog(@"ZZZZZZZZZZ %@", [[_stationArray objectAtIndex:indexPath.row] objectForKey:@"station_name"]);
        metroCell.lineTypeLabel.text = [stationDict objectForKey:@"line_1"];
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
        } else if ([metroCell.lineTypeLabel.text isEqual:@"YL"]) {
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
    if (_bikesegmentedControl.selectedSegmentIndex == 1) {
    [self performSegueWithIdentifier:@"toStationDetailSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MetroViewController *destController = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"toStationDetailSegue"]) {
        NSIndexPath *indexPath = [_resultsTableView indexPathForSelectedRow];
        NSDictionary *currentStation = [[_stationManager stationArray] objectAtIndex:indexPath.row];
        destController.stationDictionary = currentStation;
    }
}





- (IBAction)buttonTapped:(id)sender {
    

    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    [_stationManager getData];
    [_resultsTableView reloadData];
    [_tweetCollectionView reloadData];
    
    
}

- (void)didReceiveData {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    NSLog(@"Did recieve data");
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
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hostName = @"mobile-metro.herokuapp.com";
    _metroImage.hidden = true;
    _metroMapButton.hidden = true;
    _stationManager = _appDelegate.stationManager;
    [_stationManager prepareLocationMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData) name:@"ResultsDoneNotification" object:nil];
    [_resultsTableView reloadData];
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"FWcT3iE9Na5wUAdJRHHTFviyK" consumerSecret:@"M4EowAYZH6hFiEoEDabbj9ooS23GGVLGddAupr26O9Mf08GFU5"];
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        [twitter getUserTimelineWithScreenName:@"metrorailinfo" successBlock:^(NSArray *statuses) {
            self.tweetFeedArray = [NSMutableArray arrayWithArray:statuses];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.debugDescription);
    }
     
     ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [_stationManager getData];
    [_resultsTableView reloadData];
    [_tweetCollectionView reloadData];
   

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
