//
//  MetroMapViewController.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 7/22/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroMapViewController : UIViewController

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@end
