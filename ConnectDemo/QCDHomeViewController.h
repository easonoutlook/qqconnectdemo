//
//  QCDHomeViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDHomeViewController : UITableViewController <UIAlertViewDelegate> 

@property (strong, nonatomic) IBOutlet UITableViewCell *oauthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *apiCell;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end
