//
//  CommonUtil.h
//  Micropulse
//
//  Created by SZC on 14-10-15.
//  Copyright (c) 2014年 ENJOYOR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DateFormatterType)
{
    /**
     * @brief   yyyy-MM-dd
     */
    DateFormatterType1           = 1,
    /**
     * @brief   yyyy.MM.dd
     */
    DateFormatterType2           = 2,
    /**
     * @brief   yyyy-MM-dd HH:mm:ss
     */
    DateFormatterType3           = 3,
    /**
     * @brief   yyyy-MM-dd HH:mm:ss
     */
    DateFormatterTypeYYYYMMDDHHMM           = 4
};


typedef enum : NSUInteger {
    BackgroundTypeEmpty = 0,
    BackgroundTypeError,
    BackgroundTypeNetworkError
} BackgroundType;

typedef enum : NSUInteger {
    InfomationHidingMobilePhone,
    InfomationHidingName,
    InfomationHidingIDCard,
    InfomationHidingCitizenCard
} InfomationHidingType;

@interface CommonUtil : NSObject

/**
 * @brief   便捷提示框
 */
+ (void)alertWithMessage:(NSString *)message withCompletionHandler:(void (^)(void)) completionHandler;
+ (void)alertWithMessage:(NSString *)title andContent:(NSString *)content withCompletionHandler:(void (^)(void)) completionHandler;
/**
 * @brief   便捷sheet
 */
+ (void)sheetWithTitle:(NSString*)title withCompletionHandler:(void (^)(NSInteger buttonIndex)) completionHandler;
/**
 * @brief   可定义类提示框
 */
+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
         completionBlock:(void (^)(NSUInteger buttonIndex)) completionBlock;



//根据图片名字 获取不加渲染的原始图片
+ (UIImage *)getRenderingImageWithName:(NSString*)imageName;
/**
 安全获取字符串
 @param str 字符串
 @returns 若字符串为nil，则返回空字符串，否则直接返回字符串
 */
+(NSString*)strOrEmpty:(NSString*)str;

/*
 * 网络状态
 */
+ (BOOL)IsEnableWIFI;
+ (BOOL)IsEnable3G;

/**
 *  UTF8
 */
+ (NSString*)utf8WithString:(NSString*)string;

//四舍五入处理
+ (NSString *)notRounding:(float)price afterPoint:(int)position;

@end

/*
 如果字符串==nil 返回 @"" 否则返回 str
 */
extern BOOL stringIsEmpty(NSString* str);
extern NSString* strOrEmpty(NSString *str);


