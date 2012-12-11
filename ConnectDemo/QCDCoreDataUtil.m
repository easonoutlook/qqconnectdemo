//
//  QCDCoreDataUtil.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDCoreDataUtil.h"
#import "QCDAppDelegate.h"

@implementation QCDCoreDataUtil

+ (NSManagedObjectContext *)context{
	QCDAppDelegate *appDelegate = (QCDAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.managedObjectContext;
}

+ (StoredAuthInfo *)getStoredAuthInfo{
	NSManagedObjectContext *context = [self context];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"StoredAuthInfo" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDesc];
	NSArray *infos = [context executeFetchRequest:request error:nil];
	return infos.count ? [infos objectAtIndex:0] : nil;
}

+ (void)deleteAuthInfo:(StoredAuthInfo *)info{
	[[self context] deleteObject:info];
}

+ (void)saveChanges{
	[[self context] save:nil];
}

@end
