//
//  ViewController.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDictionary *availBikesDictionary;
@property (nonatomic, strong) ViewController *vc;
@property (nonatomic, strong) IBOutlet UITableView        *resultsTableView;

@end

