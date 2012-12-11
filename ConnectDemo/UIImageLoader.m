//
//  UIImageLoader.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月3日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "UIImageLoader.h"
#import "NSStringUtils.h"

@implementation UIImageView (UIImageLoader)

- (void)setImageWithURL:(NSString *)url{
	//NSLog(@"loading image from %@ ...", url);
	self.image = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error) {
			NSLog(@"FAIL TO LOAD IMAGE FROM %@ (%@)", url, error);
		}
		else {
			self.image = [UIImage imageWithData:data];
		}
	}];
}

@end
