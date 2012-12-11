//
//  QCDQzoneProfileViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDQzoneProfileViewController.h"
#import "QCDConnectApi.h"
#import "UIImageLoader.h"
#import "UILoadingAlertView.h"

@interface QCDQzoneProfileViewController ()

@end

@implementation QCDQzoneProfileViewController

- (void)fetchDataAndRender{
	UILoadingAlertView *loadingAlert = [[UILoadingAlertView alloc] initWithTitle:@"Loading" delegate:nil];
	[loadingAlert show];
	
	[QCDConnectApi getUserInfoWithSuccessHandler:^(NSDictionary *json) {
		[loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
		//update label and images when success
		[_nicknameLabel setText:[json objectForKey:@"nickname"]];
		[_isYellowVipLabel		setText:[json objectForKey:@"is_yellow_vip"]];
		[_isYellowYearVipLabel	setText:[json objectForKey:@"is_yellow_year_vip"]];
		[_yellowVipLevelLabel	setText:[json objectForKey:@"yellow_vip_level"]];
		[_qzoneFigureImage30	setImageWithURL:[json objectForKey:@"figureurl"]];
		[_qzoneFigureImage50	setImageWithURL:[json objectForKey:@"figureurl_1"]];
		[_qzoneFigureImage100	setImageWithURL:[json objectForKey:@"figureurl_2"]];
		[_qqFigureImage40		setImageWithURL:[json objectForKey:@"figureurl_qq_1"]];
		[_qqFigureImage100		setImageWithURL:[json objectForKey:@"figureurl_qq_2"]];
		
	} errorHandler:^(NSInteger retcode, NSDictionary *json, NSError *error) {
		[loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
		//show network or api error
		NSString *errorMessage;
		if (error) errorMessage = [error localizedDescription];
		else errorMessage = [NSString stringWithFormat:@"retcode=%d, msg=%@", retcode, [json objectForKey:@"msg"]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:errorMessage delegate:nil cancelButtonTitle:@":(" otherButtonTitles:nil, nil];
		[alert show];
	}];
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
	[self fetchDataAndRender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBtnTapHandler:(id)sender {
	[self fetchDataAndRender];
}

@end
