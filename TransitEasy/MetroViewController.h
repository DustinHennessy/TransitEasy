//
//  MetroViewController.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/26/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface MetroViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *stationDictionary;


@end
