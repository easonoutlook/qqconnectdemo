//
//  QCDSendTweetWithImageViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月4日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "QCDSendTweetWithImageViewController.h"
#import "UILoadingAlertView.h"
#import "QCDConnectApi.h"

@interface QCDSendTweetWithImageViewController ()

@end

@implementation QCDSendTweetWithImageViewController

- (void)sendTweetWithImage{
	if (!_selectedImageView.image || !_tweetContentTextView.text) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
														message:@"tweet content and image are required!"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil, nil];
		[alert show];
	}
	else {
		UILoadingAlertView *alert = [[UILoadingAlertView alloc] initWithTitle:@"Sending" delegate:nil];
		[alert show];
		
		[QCDConnectApi postTweetWithContent:_tweetContentTextView.text image:_selectedImageView.image successHandler:^(NSDictionary *json) {
			[alert dismissWithClickedButtonIndex:0 animated:YES];
			UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"send tweet with pic success" delegate:nil cancelButtonTitle:@"Great" otherButtonTitles:nil, nil];
			[successAlert show];
			
		} errorHandler:^(NSInteger retcode, NSDictionary *json, NSError *error) {
			[alert dismissWithClickedButtonIndex:0 animated:YES];
			NSString *errorMessage;
			if (error) errorMessage = [error localizedDescription];
			else errorMessage = [NSString stringWithFormat:@"retcode=%d, msg=%@", retcode, [json objectForKey:@"msg"]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:errorMessage delegate:nil cancelButtonTitle:@":(" otherButtonTitles:nil, nil];
			[alert show];
		}];
	}
}

- (UIImagePickerController *)launchMediaViewControllerWithType:(NSInteger)type{
	UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
	viewController.sourceType = type;
	viewController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:type];
	viewController.allowsEditing = NO;
	viewController.delegate = self;
	return viewController;
}

- (void)launchCamera{
	UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
	viewController.sourceType = UIImagePickerControllerSourceTypeCamera;
	viewController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
	viewController.allowsEditing = NO;
	viewController.delegate = self;
	[self presentViewController:viewController animated:YES completion:nil];
}

- (void)browsePhotoLibrary{
	UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
	viewController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	viewController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
	viewController.allowsEditing = NO;
	viewController.delegate = self;
	[self presentViewController:viewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:nil];
	_selectedImageView.image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
}

//hide keyboard when tap Done
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	else return YES;
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
	
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[_launchCameraBtn setEnabled:NO];
	}
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		[_browsePhotoLibraryBtn setEnabled:NO];
	}
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)browsePhotoLibraryBtnTapHandler:(id)sender {
	[self browsePhotoLibrary];
}

- (IBAction)launchCameraBtnTapHandler:(id)sender {
	[self launchCamera];
}

- (IBAction)sendTweetBtnTapHandler:(id)sender {
	[self sendTweetWithImage];
}

@end
