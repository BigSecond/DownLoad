//
//  ListViewCell.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/9.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "ListViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image.contentMode = UIViewContentModeScaleToFill;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.image.clipsToBounds  = YES;
//    [self.image setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    [_btnDownload addTarget:self action:@selector(fuckyou:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fuckyou:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell: tapeddButton:)]) {
        [self.delegate tableViewCell:self tapeddButton:button];
    }
}

-(void)setCellValues:(MainCellModel *)model{
//    self.imageView.image = [[UIImage alloc]initWithContentsOfFile:model.imgurl];
    
    
    
    self.image.backgroundColor = [UIColor colorWithRed:64/255.f green:64/255.f blue:64/255.f alpha:1];
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    //逐步下载
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.imageView.frame = CGRectMake(0,0,132,100);
        
        
    }
];
    
    //标题
    self.labelTitle.text = model.title;
    
    
    
    
//    __block UIProgressView *pv;
//    __weak typeof(self) weakSelf = self;
//    
//    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
////        UIProgressView * pv = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
//        if (pv != nil) {
//            pv = nil;
//        }
//        
//        pv = [[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
//        
//        pv.frame = CGRectMake(0, 195, weakSelf.frame.size.width, 5);
//        pv.backgroundColor = [UIColor redColor];
//        pv.progressTintColor = [UIColor greenColor];
//        
////        pv.center = self.imageView.center;
//        
////        NSLog(@"%ld,%ld",receivedSize,expectedSize);
//        
//        float currentProgress = (float)receivedSize/(float)expectedSize;
//        
//        pv.progress = currentProgress;
//        
//        [weakSelf addSubview:pv];
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        [pv removeFromSuperview];
//        
//    }];
    
}

@end
