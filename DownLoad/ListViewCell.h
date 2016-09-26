//
//  ListViewCell.h
//  DownLoad
//
//  Created by JacksonMichael on 16/8/9.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonModel.h"

@class ListViewCell;

@protocol myCellDelegate <NSObject>

@optional
- (void)tableViewCell:(ListViewCell*)cell tapeddButton:(UIButton*)button;

@end

@interface ListViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView * image;

@property (nonatomic,weak) IBOutlet UILabel * labelTitle;

@property (nonatomic,weak) IBOutlet UIButton * btnDownload;


-(void)setCellValues:(MainCellModel *)model;

@property (nonatomic, weak) id<myCellDelegate> delegate;


@end


