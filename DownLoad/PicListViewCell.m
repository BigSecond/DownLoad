//
//  PicListViewCell.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/14.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "PicListViewCell.h"

@implementation PicListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_deleteBtn addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
    [_collectionBtn addTarget:self action:@selector(collectionPic:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deletePic:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell: deleteButton:)]) {
        [self.delegate tableViewCell:self deleteButton:button];
    }
}

- (void)collectionPic:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell: collectionButton:)]) {
        [self.delegate tableViewCell:self collectionButton:button];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
