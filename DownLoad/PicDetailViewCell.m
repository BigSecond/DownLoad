//
//  PicDetailViewCell.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/10.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "PicDetailViewCell.h"

@implementation PicDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.image.contentMode = UIViewContentModeCenter;
//    self.image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.image.clipsToBounds  = YES;
    self.image.contentMode = UIViewContentModeScaleToFill;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.image.clipsToBounds  = YES;
    [self.image setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValues:(NSString *)picPath andPicName:(NSString *)picName{
    //    self.imageView.image = [[UIImage alloc]initWithContentsOfFile:model.imgurl];
    
    self.image.backgroundColor = [UIColor colorWithRed:64/255.f green:64/255.f blue:64/255.f alpha:1];
    
    self.image.image = [self loadImage:picName ofType:@"jpg" inDirectory:picPath];
    
}


- (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}
@end
