//
//  QCDFollowListCell.m
//  ConnectDemo
//
//  Created by Oscar Tong on 12年12月6日.
//  Copyright (c) 2012年 Oscar Tong. All rights reserved.
//

#import "QCDFollowListCell.h"
#import "UIImageLoader.h"

@implementation QCDFollowListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellContentWithDictionary:(NSDictionary *)dic{
	//weibo api could return empty head field :( use default avatar here ?
	NSString *headURL = [dic objectForKey:@"head"];
	if (headURL && headURL.length) {
		[_avatarImageView setImageWithURL:[NSString stringWithFormat:@"%@/50", [dic objectForKey:@"head"]]];
	}
	else {
		_avatarImageView.image = nil;
	}
	[_nickLabel setText:[dic objectForKey:@"nick"]];
	[_nameLabel setText:[dic objectForKey:@"name"]];
}

@end
