//
//  ScheduleTableViewCell.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *availBikesLabel;
@property (nonatomic, strong) IBOutlet UILabel *emptyDocksLabel;
@property (nonatomic, strong) IBOutlet UILabel *stationNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *stationAddressLabel;
@property (nonatomic, strong) IBOutlet UILabel *lineTypeLabel;

@end
