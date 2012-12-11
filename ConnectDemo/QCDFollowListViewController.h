//
//  QCDFollowListViewController.h
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDFollowListViewController : UITableViewController {
	NSMutableArray *followList;
}

- (void)showMyFollowerList;
- (void)showMyFollowingList;

@end
