//
//  QCDQzoneProfileViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDQzoneProfileViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *qzoneFigureImage30;
@property (strong, nonatomic) IBOutlet UIImageView *qzoneFigureImage50;
@property (strong, nonatomic) IBOutlet UIImageView *qzoneFigureImage100;
@property (strong, nonatomic) IBOutlet UIImageView *qqFigureImage40;
@property (strong, nonatomic) IBOutlet UIImageView *qqFigureImage100;
@property (strong, nonatomic) IBOutlet UILabel *isYellowVipLabel;
@property (strong, nonatomic) IBOutlet UILabel *isYellowYearVipLabel;
@property (strong, nonatomic) IBOutlet UILabel *yellowVipLevelLabel;

@end
