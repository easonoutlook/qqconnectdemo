//
//  QCDManageFollowerViewController.m
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDManageFollowingViewController.h"
#import "QCDConnectApi.h"
#import "UILoadingAlertView.h"

@interface QCDManageFollowingViewController ()

@end

@implementation QCDManageFollowingViewController

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
	[_nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMode:(NSInteger)mode{
	manageMode = mode;
	switch (manageMode) {
		case QCD_MANAGE_FOLLOWER_ADD:
			[self setTitle:@"新增收听"];
			[self.navigationItem.rightBarButtonItem setTitle:@"Add"];
			break;
			
		case QCD_MANAGE_FOLLOWER_DEL:
			[self setTitle:@"取消收听"];
			[self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
			break;
	}
}

- (IBAction)btnTapHandler:(id)sender {
	NSString *name = _nameTextField.text;
	if (name) {
		UILoadingAlertView *alert = [[UILoadingAlertView alloc] initWithTitle:@"Wait ..." delegate:nil];
		[alert show];
		
		switch (manageMode) {
			case QCD_MANAGE_FOLLOWER_ADD: {
				[QCDConnectApi addFollowingWithName:name sccessHandler:^(NSDictionary *json) {
					[alert dismissWithClickedButtonIndex:0 animated:YES];
					UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Done" message:[NSString stringWithFormat:@"follow %@ success", name] delegate:nil cancelButtonTitle:@"Great" otherButtonTitles:nil, nil];
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
			break;
				
			case QCD_MANAGE_FOLLOWER_DEL: {
				[QCDConnectApi deleteFollowingWithName:name sccessHandler:^(NSDictionary *json) {
					[alert dismissWithClickedButtonIndex:0 animated:YES];
					UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Done" message:[NSString stringWithFormat:@"unfollow %@ success", name] delegate:nil cancelButtonTitle:@"Great" otherButtonTitles:nil, nil];
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
			break;
		}
	}
	else {
		
	}
}

@end
