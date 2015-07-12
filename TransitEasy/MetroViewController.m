//
//  MetroViewController.m
//  TransitEasy
//
//  Created by Dustin Hennessy on 6/26/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "MetroViewController.h"
#import "StationsTableViewCell.h"


@interface MetroViewController ()

@property (nonatomic, strong) NSArray *trainInfoArray;



@end

@implementation MetroViewController


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"trainsCell";
    StationsTableViewCell *cell = (StationsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
