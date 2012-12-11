//
//  QCDSendTweetViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月4日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDSendTweetViewController.h"
#import "UILoadingAlertView.h"
#import "QCDConnectApi.h"

@interface QCDSendTweetViewController ()

@end

@implementation QCDSendTweetViewController

- (void)sendTweet{
	UILoadingAlertView *alert = [[UILoadingAlertView alloc] initWithTitle:@"Sending" delegate:nil];
	[alert show];
	
	//send tweet with qq connect api
	NSString *content = [_tweetContentView text];
	double latitude = location ? location.coordinate.latitude : 0.0;
	double longitude = location ? location.coordinate.longitude : 0.0;
	[QCDConnectApi postTweetWithContent:content longitude:longitude latitude:latitude sccessHandler:^(NSDictionary *json) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		//show success alert
		UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"send tweet success" delegate:nil cancelButtonTitle:@"Great" otherButtonTitles:nil, nil];
		[successAlert show];
		
	} errorHandler:^(NSInteger retcode, NSDictionary *json, NSError *error) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		//show network or api error
		NSString *errorMessage;
		if (error) errorMessage = [error localizedDescription];
		else errorMessage = [NSString stringWithFormat:@"retcode=%d, msg=%@", retcode, [json objectForKey:@"msg"]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:errorMessage delegate:nil cancelButtonTitle:@":(" otherButtonTitles:nil, nil];
		[alert show];
	}];
}

- (void)startGettingLocation{
	if ([CLLocationManager locationServicesEnabled]) {
		if (!locationManager) {
			locationManager = [[CLLocationManager alloc] init];
			locationManager.delegate = self;
		}
		[locationManager startUpdatingLocation];
		[_coordinateFetchingIndicator startAnimating];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNNING" message:@"LOCATION SERVICE IS DISABLED" delegate:nil cancelButtonTitle:@"-__-" otherButtonTitles:nil, nil];
		[alert show];
	}
}

- (void)clearLocationInfo{
	location = nil;
	[locationManager stopUpdatingLocation];
	[_coordinateFetchingIndicator stopAnimating];
	_coordinateField.text = @"0, 0";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	//stop updating location, i only need one-time data
	[locationManager stopUpdatingLocation];
	[_coordinateFetchingIndicator stopAnimating];
	
	//store data and update ui
	location = [locations objectAtIndex:0];
	_coordinateField.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
	NSLog(@"your location is %@", location);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[_tweetContentView becomeFirstResponder];
	[_tweetContentView selectAll:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnTapHandler:(id)sender {
	[self sendTweet];
}

- (IBAction)locationSwitchChangeHandler:(id)sender {
	if (_locationSwitch.on) [self startGettingLocation];
	else [self clearLocationInfo];
}

@end
