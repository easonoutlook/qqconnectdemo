//
//  QCDDetailViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
