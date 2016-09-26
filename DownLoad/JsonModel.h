//
//  JsonModel.h
//  DownLoad
//
//  Created by JacksonMichael on 16/8/9.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonModel : NSObject

@end

@interface MainCellModel : NSObject

@property (nonatomic,copy) NSString * imgurl;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * herf;

@property (nonatomic,assign) BOOL btnflag;


@end


@interface DownLoadModel : NSObject

//图片地址数组
@property (nonatomic,strong) NSMutableArray * urlArray;
//图片文件夹标题
@property (nonatomic,copy) NSString * titleName;
////保存本地路径地址    //暂不用
//@property (nonatomic,copy) NSString * pathdisk;


@end

