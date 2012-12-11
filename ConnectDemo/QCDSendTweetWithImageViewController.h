//
//  QCDSendTweetWithImageViewController.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月4日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDSendTweetWithImageViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *tweetContentTextView;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *browsePhotoLibraryBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *launchCameraBtn;

@end
