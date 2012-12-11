//
//  QCDOAuthViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface QCDOAuthViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
