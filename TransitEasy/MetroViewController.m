//
//  MetroViewController.m
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/26/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "MetroViewController.h"
#import "StationsTableViewCell.h"
#import "ViewController.h"
#import "UIColor+Metro.h"


@interface MetroViewController ()

@property (nonatomic, strong) NSArray *trainInfoArray;
@property (nonatomic, strong) IBOutlet UITableView *trainTableView;


@end

@implementation MetroViewController


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trainInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"trainsCell";
    StationsTableViewCell *cell = (StationsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.destinationLabel.text = [[_trainInfoArray objectAtIndex:indexPath.row] objectForKey:@"destination"];
    cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"%li minutes", (long)[[[_trainInfoArray objectAtIndex:indexPath.row] objectForKey:@"min"]integerValue]];
    cell.colorLabel.text = [[_trainInfoArray objectAtIndex:indexPath.row] objectForKey:@"line"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.colorLabel.text  isEqual: @"BL"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroBlueColor]];
    } else if ([cell.colorLabel.text  isEqual: @"OR"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroOrangeColor]];
    } else if ([cell.colorLabel.text  isEqual: @"GR"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroGreenColor]];
    } else if ([cell.colorLabel.text isEqual:@"SV"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroSilverColor]];
    } else if ([cell.colorLabel.text isEqual:@"RD"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroRedColor]];
    } else if ([cell.colorLabel.text isEqual:@"YW"]) {
        [cell.colorLabel setBackgroundColor:[UIColor metroYellowColor]];
    }
    
    return cell;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"SD: %@",_stationDictionary);
    _trainInfoArray = [(NSDictionary *) _stationDictionary objectForKey:@"upcoming_trains"];
    NSLog(@"****************:%li",_trainInfoArray.count);
    [_trainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
