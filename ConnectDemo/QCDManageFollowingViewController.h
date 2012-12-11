//
//  QCDManageFollowerViewController.h
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

enum followingViewControllerMode{
	QCD_MANAGE_FOLLOWER_ADD,
	QCD_MANAGE_FOLLOWER_DEL
};

@interface QCDManageFollowingViewController : UITableViewController {
	NSInteger manageMode;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

- (void)setMode:(NSInteger)mode;

@end
