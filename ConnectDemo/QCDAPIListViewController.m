//
//  QCDAPIListViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月4日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDAPIListViewController.h"
#import "QCDManageFollowingViewController.h"
#import "QCDFollowListViewController.h"

@interface QCDAPIListViewController ()

@end

@implementation QCDAPIListViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"addIdolSegue"]) {
		QCDManageFollowingViewController *viewController = (QCDManageFollowingViewController *)segue.destinationViewController;
		[viewController setMode:QCD_MANAGE_FOLLOWER_ADD];
	}
	else if ([segue.identifier isEqualToString:@"delIdolSegue"]) {
		QCDManageFollowingViewController *viewController = (QCDManageFollowingViewController *)segue.destinationViewController;
		[viewController setMode:QCD_MANAGE_FOLLOWER_DEL];
	}
	else if ([segue.identifier isEqualToString:@"myFollowerSegue"]) {
		QCDFollowListViewController *viewController = (QCDFollowListViewController *)segue.destinationViewController;
		[viewController showMyFollowerList];
	}
	else if ([segue.identifier isEqualToString:@"myFollowingSegue"]) {
		QCDFollowListViewController *viewController = (QCDFollowListViewController *)segue.destinationViewController;
		[viewController showMyFollowingList];
	}
}

@end
