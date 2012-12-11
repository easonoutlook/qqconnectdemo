//
//  QCDCoreDataUtil.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoredAuthInfo.h"

@interface QCDCoreDataUtil : NSObject

+ (StoredAuthInfo *)getStoredAuthInfo;
+ (void)deleteAuthInfo:(StoredAuthInfo *)info;
+ (void)saveChanges;

@end
