//
//  StationsTableViewCell.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/11/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *destinationLabel;
@property (nonatomic, strong) UILabel *arrivalTimeLabel;
@property (nonatomic, strong) UILabel *colorLabel;

@end
