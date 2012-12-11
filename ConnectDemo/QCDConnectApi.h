//
//  QCDConnectApi.h
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月3日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCDConnectApi : NSObject

+ (void)getUserInfoWithSuccessHandler:(void (^)(NSDictionary *))successHandler
						   errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)postTweetWithContent:(NSString *)content
				   longitude:(double)longitude
					latitude:(double)latitude
			   sccessHandler:(void (^)(NSDictionary *))successHandler
				errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)postTweetWithContent:(NSString *)content
					   image:(UIImage *)image
			  successHandler:(void (^)(NSDictionary *))successHandler
				errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)addFollowingWithName:(NSString *)name
			   sccessHandler:(void (^)(NSDictionary *))successHandler
				errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)deleteFollowingWithName:(NSString *)name
				  sccessHandler:(void (^)(NSDictionary *))successHandler
				   errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)getFollowerListFromIndex:(NSInteger)startIndex
						   count:(NSInteger)count
				   sccessHandler:(void (^)(NSDictionary *))successHandler
					errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

+ (void)getFollowingListFromIndex:(NSInteger)startIndex
							count:(NSInteger)count
					sccessHandler:(void (^)(NSDictionary *))successHandler
					 errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *error))errorHandler;

@end
