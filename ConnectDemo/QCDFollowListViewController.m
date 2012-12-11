//
//  QCDFollowListViewController.m
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDFollowListViewController.h"
#import "QCDConnectApi.h"
#import "UILoadingAlertView.h"
#import "QCDFollowListCell.h"

@interface QCDFollowListViewController ()

@end

@implementation QCDFollowListViewController

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
	followList = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMyFollowerList{
	[self setTitle:@"听众列表"];
	
	UILoadingAlertView *alert = [[UILoadingAlertView alloc] initWithTitle:@"Loading ..." delegate:nil];
	[alert show];

	[QCDConnectApi getFollowerListFromIndex:0 count:30 sccessHandler:^(NSDictionary *json) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		NSArray *list = [[json objectForKey:@"data"] objectForKey:@"info"];
		[followList addObjectsFromArray:list];
		[self.tableView reloadData];
		
	} errorHandler:^(NSInteger retcode, NSDictionary *json, NSError *error) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
	}];
}

- (void)showMyFollowingList{
	[self setTitle:@"收听列表"];
	
	UILoadingAlertView *alert = [[UILoadingAlertView alloc] initWithTitle:@"Loading ..." delegate:nil];
	[alert show];
	
	[QCDConnectApi getFollowingListFromIndex:0 count:30 sccessHandler:^(NSDictionary *json) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		NSArray *list = [[json objectForKey:@"data"] objectForKey:@"info"];
		[followList addObjectsFromArray:list];
		[self.tableView reloadData];
		
	} errorHandler:^(NSInteger retcode, NSDictionary *json, NSError *error) {
		[alert dismissWithClickedButtonIndex:0 animated:YES];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return followList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QCDFollowListCell *cell = (QCDFollowListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	[cell updateCellContentWithDictionary:[followList objectAtIndex:indexPath.row]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
