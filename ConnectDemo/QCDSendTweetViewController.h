//
//  QCDSendTweetViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月4日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface QCDSendTweetViewController : UITableViewController <UITextViewDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *location;
};

//tweet content
@property (strong, nonatomic) IBOutlet UITextView *tweetContentView;

//geolocation
@property (strong, nonatomic) IBOutlet UITableViewCell *coordinateCell;
@property (strong, nonatomic) IBOutlet UILabel *coordinateField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *coordinateFetchingIndicator;

//geolocation switch
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@end
