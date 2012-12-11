//
//  QCDOAuthViewController.m
//  ConnectDemo
//
//  Created by JoJo Chow on 12年11月30日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDOAuthViewController.h"
#import "QCDAppDelegate.h"
#import "QCDAppConst.h"
#import "StoredAuthInfo.h"

@interface QCDOAuthViewController ()

@end

@implementation QCDOAuthViewController


- (NSDictionary *)parseQuery:(NSString *)query{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	for (NSString *item in [query componentsSeparatedByString:@"&"]) {
		NSArray *keyValue = [item componentsSeparatedByString:@"="];
		[dic setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
	}
	return [NSDictionary dictionaryWithDictionary:dic];
}


- (StoredAuthInfo *)saveAccessToken:(NSString *)accessToken whichExpiresIn:(double)seconds withOpenid:(NSString *)openid{
	//get managed object context
	QCDAppDelegate *delegate = (QCDAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	NSError *error = nil;
	StoredAuthInfo *info = nil;
	
	//prepare to search for existed record (override existed record)
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"StoredAuthInfo" inManagedObjectContext:context];
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"openid == %@", openid];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDesc];
	//[request setPredicate:predicate];
	
	//find existed record with specify openid
	NSArray *existedInfos = [context executeFetchRequest:request error:nil];
	NSLog(@"%d existed info(s)", existedInfos.count);
	if (existedInfos != nil && existedInfos.count) {
		info = [existedInfos objectAtIndex:0];
	}
	else {
		//if no existed record is found, then create a new one
		info = [NSEntityDescription insertNewObjectForEntityForName:@"StoredAuthInfo" inManagedObjectContext:context];
	}
	
	//update token information
	info.openid = openid;
	info.accessToken = accessToken;
	info.expireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
	
	//save back to coredata
	if ([context save:&error]) {
		NSLog(@"successfully saved oauth2.0 results");
	}
	else{
		NSLog(@"FAIL TO SAVE OAUTH2.0 RESULTS! %@", error);
	}
	
	return info;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//start loading oauth2.0 page
	NSString *url = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/authorize?response_type=token&client_id=%@&redirect_uri=%@&scope=%@,%@&state=%d",
					 APPID,
					 @"www.qq.com",
					 @"get_simple_userinfo,add_topic,add_one_blog,add_album,upload_pic,list_album,add_share,check_page_fans", //qzone api
					 @"add_t,add_pic_t,del_t,get_repost_list,get_info,get_other_info,get_fanlist,get_idolist,add_idol,del_idol", //weibo api
					 123];
	NSLog(@"requesting user login and authorization at %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self.webview loadRequest:request];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
	[_indicator startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[_indicator stopAnimating];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	//oauth2.0 callback
	if ([request.URL.host isEqualToString:@"www.qq.com"]) {
		
		//access_token, expires_in, state
		NSDictionary *tokens = [self parseQuery:request.URL.fragment];
		NSLog(@"token: %@", tokens);
		
		//fetch openid
		[_indicator startAnimating];
		NSString *openidURL = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@", [tokens objectForKey:@"access_token"]];
		NSURLRequest *openidRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:openidURL]];
		[NSURLConnection sendAsynchronousRequest:openidRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			[_indicator stopAnimating];
			if (!error) {
				NSString *responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				//extract openid from response text
				NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"callback\\((.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
				NSTextCheckingResult *match = [regex firstMatchInString:responseText options:0 range:NSMakeRange(0, responseText.length)];
				if (match.numberOfRanges == 2) {
					NSString *json = [responseText substringWithRange:[match rangeAtIndex:1]];
					NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
					NSLog(@"openid: %@", result);
					
					//save tokens and openid to core data
					double expiresIn = [[tokens objectForKey:@"expires_in"] doubleValue];
					NSString *accessToken = [tokens objectForKey:@"access_token"];
					NSString *openid = [result objectForKey:@"openid"];
					[self saveAccessToken:accessToken whichExpiresIn:expiresIn withOpenid:openid];
				}
				else NSLog(@"FAIL TO MATCH OPENID! %@", responseText);
			}
			else {
				NSLog(@"FAIL TO FETCH OPENID! %@", error);
			}
			
			//go back to home view
			[self.navigationController popToRootViewControllerAnimated:YES];
		}];
		return NO;
	}
	
	//others
	return YES;
}

@end
