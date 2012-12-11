//
//  QCDHomeViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDHomeViewController.h"
#import "QCDCoreDataUtil.h"
#import "StoredAuthInfo.h"

@interface QCDHomeViewController ()

@end

@implementation QCDHomeViewController

- (void)updateLoginStatus{
	StoredAuthInfo *info = [QCDCoreDataUtil getStoredAuthInfo];
	if (info) {
		NSLog(@"StoredAuthInfo: %@ %@ %@", info.accessToken, info.openid, info.expireDate);
		//show expired date
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeZone:[NSTimeZone localTimeZone]];
		[_oauthCell.detailTextLabel setText:[NSString stringWithFormat:@"token有效至%@", [formatter stringFromDate:info.expireDate]]];
		
		//enable logout button
		[_logoutButton setEnabled:YES];
	}
	else {
		[_oauthCell.detailTextLabel setText:@"尚未登录"];
		[_logoutButton setEnabled:NO];
	}
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
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self updateLoginStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutButtonTap:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
	[alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex) {
		StoredAuthInfo *info = [QCDCoreDataUtil getStoredAuthInfo];
		[QCDCoreDataUtil deleteAuthInfo:info];
		[QCDCoreDataUtil saveChanges];
		[self updateLoginStatus];
	}
}

@end
