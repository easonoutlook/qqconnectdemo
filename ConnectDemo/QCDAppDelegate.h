//
//  QCDAppDelegate.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
