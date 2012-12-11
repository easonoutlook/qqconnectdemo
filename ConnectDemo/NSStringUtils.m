//
//  NSStringUtils.m
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "NSStringUtils.h"

@implementation NSString (NSStringUtils)

- (NSString *)urlencode{
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

@end
