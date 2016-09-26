//
//  PicListViewCell.h
//  DownLoad
//
//  Created by JacksonMichael on 16/8/14.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicListViewCell;

@protocol PicListCellDelegate <NSObject>

@optional
- (void)tableViewCell:(PicListViewCell*)cell collectionButton:(UIButton*)button;
- (void)tableViewCell:(PicListViewCell*)cell deleteButton:(UIButton*)button;

@end

@interface PicListViewCell : UITableViewCell

@property (weak) IBOutlet NSLayoutConstraint *constraint;
//删除按钮
@property (nonatomic,weak) IBOutlet UIButton * deleteBtn;
//收藏按钮
@property (nonatomic,weak) IBOutlet UIButton * collectionBtn;
//标题标签
@property (nonatomic,weak) IBOutlet UILabel * titleLabel;
//属性标签
@property (nonatomic,weak) IBOutlet UILabel * attributeLabel;
//图片数量
@property (nonatomic,assign) int imagesCount;

@property (nonatomic, weak) id<PicListCellDelegate> delegate;
@end
