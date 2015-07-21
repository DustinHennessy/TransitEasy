//
//  StationsTableViewCell.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/11/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrivalTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *colorLabel;

@end
