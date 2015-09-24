//
//  TweetCollectionViewCell.h
//  TransitEasy
//
//  Created by Dustin Hennessy on 9/2/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UILabel     *twitterHandleLabel;
@property (nonatomic, strong) IBOutlet UITextView  *tweetTextView;


@end
