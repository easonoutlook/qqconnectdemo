//
//  QCDLoadingAlertView.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月3日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "UILoadingAlertView.h"

@implementation UILoadingAlertView

- (id)initWithTitle:(NSString *)title delegate:(id)delegate{
	return [self initWithTitle:title message:nil delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = CGPointMake(139.5, 68.5);
		[self addSubview:spinner];
		[spinner startAnimating];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
