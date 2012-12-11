//
//  QCDConnectApi.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年12月3日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDConnectApi.h"
#import "QCDAppConst.h"
#import "QCDCoreDataUtil.h"
#import "NSStringUtils.h"
#import "StoredAuthInfo.h"

static NSInteger DEFAULT_API_TIMEOUT = 10;

static NSString *API_GET_SIMPLE_USERINFO	= @"https://graph.qq.com/user/get_simple_userinfo?%@";
static NSString *API_POST_TWEET				= @"https://graph.qq.com/t/add_t";
static NSString *API_POST_TWEET_WITH_IMAGE	= @"https://graph.qq.com/t/add_pic_t";
static NSString *API_ADD_FOLLOWING			= @"https://graph.qq.com/relation/add_idol";
static NSString *API_DEL_FOLLOWING			= @"https://graph.qq.com/relation/del_idol";
static NSString *API_GET_FOLLOWER_LIST		= @"https://graph.qq.com/relation/get_fanslist?%@&reqnum=%d&startindex=%d";
static NSString *API_GET_FOLLOWING_LIST		= @"https://graph.qq.com/relation/get_idollist?%@&reqnum=%d&startindex=%d";

static NSString *API_POST_TWEET_BODY		= @"%@&content=%@&longitude=%f&latitude=%f";
static NSString *API_ADD_FOLLOWING_BODY		= @"%@&name=%@";
static NSString *API_DEL_FOLLOWING_BODY		= @"%@&name=%@";


@implementation QCDConnectApi


+ (NSString *)getCommonParams{
	StoredAuthInfo *info = [QCDCoreDataUtil getStoredAuthInfo];
	NSString *accessToken = info ? info.accessToken : @"";
	NSString *openid = info ? info.openid : @"";
	return [NSString stringWithFormat:@"access_token=%@&openid=%@&oauth_consumer_key=%@&format=json", accessToken, openid, APPID];
}


+ (NSData *)formDataItemWithName:(NSString *)name value:(NSString *)value boundary:(NSString *)boundary{
	NSString *item = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n--%@\r\n", name, value, boundary];
	return [item dataUsingEncoding:NSUTF8StringEncoding];
}


+ (void)fetchDataFrom:(NSURLRequest *)request
	   successHandler:(void (^)(NSDictionary *))successHandler
		 errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSString *url = request.URL.absoluteString;
	NSOperationQueue *queue = [NSOperationQueue currentQueue];
	NSLog(@"fetching data from %@", url);
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error != nil) {
			NSLog(@"ERROR WHEN FETCHING DATA FROM %@ (%@)", url, error);
			if(errorHandler) errorHandler(0, nil, error);
		}
		else {
			//parse server's response and check retcode
			NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			NSInteger retcode = [[json objectForKey:@"ret"] intValue];
			NSLog(@"result from %@: %@", url, json);
			
			//invoke success or error handler according to error code
			if (retcode && errorHandler) errorHandler(retcode, json, nil);
			else if (successHandler) successHandler(json);
		}
	}];
}


+ (void)getUserInfoWithSuccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSString *url = [NSString stringWithFormat:API_GET_SIMPLE_USERINFO, [self getCommonParams]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:DEFAULT_API_TIMEOUT];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)postTweetWithContent:(NSString *)content longitude:(double)longitude latitude:(double)latitude sccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_POST_TWEET]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:DEFAULT_API_TIMEOUT];
	NSString *body = [NSString stringWithFormat:API_POST_TWEET_BODY, [self getCommonParams], [content urlencode], longitude, latitude];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)postTweetWithContent:(NSString *)content image:(UIImage *)image successHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	//create request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_POST_TWEET_WITH_IMAGE]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:DEFAULT_API_TIMEOUT];
	//initialize request header
	NSString *boundary = @"jafoefh349s239409q3hfqoefhsaf3o9";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request setHTTPMethod:@"POST"];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	//prepare the request body
	StoredAuthInfo *info = [QCDCoreDataUtil getStoredAuthInfo];
	NSString *accessToken = info ? info.accessToken : @"";
	NSString *openid = info ? info.openid : @"";
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[self formDataItemWithName:@"access_token"			value:accessToken	boundary:boundary]];
	[body appendData:[self formDataItemWithName:@"openid"				value:openid		boundary:boundary]];
	[body appendData:[self formDataItemWithName:@"oauth_consumer_key"	value:APPID			boundary:boundary]];
	[body appendData:[self formDataItemWithName:@"format"				value:@"json"		boundary:boundary]];
	[body appendData:[self formDataItemWithName:@"content"				value:content		boundary:boundary]];
	
	//append the image binary data to request body
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"pic.jpeg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:UIImageJPEGRepresentation(image, 0.8)];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	//send the request
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)addFollowingWithName:(NSString *)name sccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_ADD_FOLLOWING]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:DEFAULT_API_TIMEOUT];
	NSString *body = [NSString stringWithFormat:API_ADD_FOLLOWING_BODY, [self getCommonParams], [name urlencode]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)deleteFollowingWithName:(NSString *)name sccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_DEL_FOLLOWING]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:DEFAULT_API_TIMEOUT];
	NSString *body = [NSString stringWithFormat:API_DEL_FOLLOWING_BODY, [self getCommonParams], [name urlencode]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)getFollowerListFromIndex:(NSInteger)startIndex count:(NSInteger)count sccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSString *url = [NSString stringWithFormat:API_GET_FOLLOWER_LIST, [self getCommonParams], count, startIndex];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:DEFAULT_API_TIMEOUT];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}


+ (void)getFollowingListFromIndex:(NSInteger)startIndex count:(NSInteger)count sccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSInteger, NSDictionary *, NSError *))errorHandler{
	NSString *url = [NSString stringWithFormat:API_GET_FOLLOWING_LIST, [self getCommonParams], count, startIndex];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:DEFAULT_API_TIMEOUT];
	[self fetchDataFrom:request successHandler:successHandler errorHandler:errorHandler];
}

@end
