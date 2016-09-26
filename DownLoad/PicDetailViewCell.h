//
//  PicDetailViewCell.h
//  DownLoad
//
//  Created by JacksonMichael on 16/8/10.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView * image;


- (void)setCellValues:(NSString *)picPath andPicName:(NSString *)picName;
@end
