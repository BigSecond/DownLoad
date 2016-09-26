//
//  CommonUtil.m
//  Micropulse
//
//  Created by SZC on 14-10-15.
//  Copyright (c) 2014年 ENJOYOR. All rights reserved.
//


/**
 *  宏定义
 *
 */
#define IOS8ORLATER   [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0

#define kScreen_height [[UIScreen mainScreen] bounds].size.height
#define kScreen_width [[UIScreen mainScreen] bounds].size.width

#import "CommonUtil.h"
#import "MBHUDUntil.h"

@implementation CommonUtil

+ (void)alertWithMessage:(NSString *)message withCompletionHandler:(void (^)(void)) completionHandler
{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
     [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:NULL];
    
}

+ (void)alertWithMessage:(NSString *)title andContent:(NSString *)content withCompletionHandler:(void (^)(void)) completionHandler
{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:NULL];
    
}

+ (void)sheetWithTitle:(NSString*)title withCompletionHandler:(void (^)(NSInteger buttonIndex)) completionHandler
{
    if (IOS8ORLATER) {
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (completionHandler) {
                completionHandler(0);
            }
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (completionHandler) {
                completionHandler(1);
            }
        }]];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:NULL];
    }else{
        
        
    }
}

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
         completionBlock:(void (^)(NSUInteger buttonIndex)) completionBlock{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *buttonTitle in buttonTitles) {
        [alert addAction:[UIAlertAction actionWithTitle:buttonTitle
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    completionBlock([buttonTitles indexOfObject:buttonTitle]);
                                                }]];
    }
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:NULL];
    
}
+ (NSDate *)dateFromString:(NSString *)dateString WithType:(DateFormatterType)type
{
    NSString * formatterString = nil;
    
    switch (type) {
        case 1:
            formatterString = @"yyyy-MM-dd";
            break;
        case 2:
            formatterString = @"yyyy.MM.dd";
            break;
        case 3:
            formatterString = @"yyyy-MM-dd HH:mm:ss";
            break;
        case 4:
            formatterString = @"yyyy-MM-dd HH:mm";
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: formatterString];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate*)aDate WithType:(DateFormatterType)type
{
    NSString * formatterString = nil;
    
    switch (type) {
        case 1:
            formatterString = @"yyyy-MM-dd";
            break;
        case 2:
            formatterString = @"yyyy.MM.dd";
            break;
        case 3:
            formatterString = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: formatterString];
    NSString *destDate= [dateFormatter stringFromDate:aDate];
    
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate *)aDate WithFormatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatter];
    NSString *destDate= [dateFormatter stringFromDate:aDate];
    
    return destDate;
}


//------------------------------------------------------------------------------
+ (NSString *)localStringFromDistance:(double)distance{
    if(distance == 0){
        return @"未知";
    }else if (distance < 1000) {//1km内
        return [NSString stringWithFormat:@"%f米内",distance];
    }else if (distance <= 3000){
        return [NSString stringWithFormat:@"%0.0f公里内",distance/1000+1];
    }else if (distance <= 10000){
        return [NSString stringWithFormat:@"%0.0f公里外",distance/1000];
    }else{
        return @"在火星上";
    }
}
//------------------------------------------------------------------------------
+ (BOOL)isNumber:(NSString *)string{
    NSString *regex = @"^\\d$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:string];
}

+ (BOOL)isEmail:(NSString *)email{
    NSString *regex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:email];
}

+ (BOOL)validId18:(NSString *)idNumber{
    NSArray *powers = @[@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2"];
    NSArray *parityBits = @[@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2"];
    NSString *num = [idNumber substringWithRange:NSMakeRange(0, 17)];
    NSString *parityBit = [idNumber substringWithRange:NSMakeRange(17, 1)];
    int power = 0;
    for(int i=0;i<17;i++){
        NSString *str = [num substringWithRange:NSMakeRange(i, 1)];
        //校验每一位的合法性
        if( str.intValue>=0 && str.intValue<=9){
            //加权
            power += [str intValue]*[powers[i] intValue];
        }else{//非数字
            return NO;
        }
    }
    //取模
    int mod = power%11;
    return [parityBits[mod] isEqualToString:parityBit];
}


+ (CGFloat)heightForLabelWithText:(NSString *)content width:(CGFloat)width font:(UIFont *)font{
    NSDictionary * attributes =  @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};//字体
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    if (height==0) {
        return font.lineHeight;
    }else{
        return height;
    }
}
+ (CGFloat)widthForLabelWithText:(NSString *)content height:(CGFloat)height font:(UIFont *)font{
    NSDictionary * attributes =  @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};//字体
    CGFloat width = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
    if (height==0) {
        return font.lineHeight;
    }else{
        return width;
    }

}
+ (UIImage *)getRenderingImageWithName:(NSString*)imageName{
    
    UIImage * image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+(NSString*)strOrEmpty:(NSString*)str
{
    if ((NSNull*)str==[NSNull null]) {
        return @"";
    }
    return (str==nil?@"":str);
}
+(instancetype)objectOrEmpty:(id)obj
{
    if ((NSNull*)obj==[NSNull null]) {
        return nil;
    }
    return obj;
}

+ (NSString *)informationHiding:(NSString *)string infomationHidingType:(InfomationHidingType)type{
    if(string.length < 2){
        return string;
    }
    NSString *ret = nil;
    switch (type) {
        case InfomationHidingMobilePhone:{//手机号码中间4位用“*”显示
            NSUInteger length = string.length;
            NSString *hideString = @"****";
            if (length <= 2) {
                return string;
            }else{
                if (length < 8 && length >= 3) {
                    ret = [string stringByReplacingCharactersInRange:NSMakeRange(3, length - 3) withString:hideString];
                    ret = [ret substringToIndex:length];
                    return ret;
                }
                ret = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:hideString];
            }
        }
            break;
        case InfomationHidingIDCard:{//身份证号码除前三位及后六位，其余数字用“*”显示
            NSInteger length = string.length;
            NSString *hideString = @"";
            for (int i=1; i<=length; i++) {
                if (i>3 && i<=length-6) {
                    hideString = [hideString stringByAppendingString:@"*"];
                }
            }
            ret = [string stringByReplacingCharactersInRange:NSMakeRange(3, length-9) withString:hideString];
            break;
        }
        case InfomationHidingCitizenCard:{//市民卡号除第一位，其他数字用“*”显示
            NSInteger length = string.length;
            NSString *hideString = @"";
            for (int i=1; i<=length; i++) {
                if (i>1) {
                    hideString = [hideString stringByAppendingString:@"*"];
                }
            }
            ret = [string stringByReplacingCharactersInRange:NSMakeRange(1, length-1) withString:hideString];
            break;
        }
        case InfomationHidingName:{//姓名：若为两个字，则用“*”代替第一个字；若为三个字，则用“*”代替第二个字；若为四个字或以上，则保留最后两个字，其余用“*”代替
            NSInteger length = string.length;
            if(length==2){
                ret = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            }else if(length == 3){
                ret = [string stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
            }else{
                NSString *hideString = @"";
                for (int i=1; i<=length; i++) {
                    if (i<=length-2) {
                        hideString = [hideString stringByAppendingString:@"*"];
                    }
                }
                ret = [string stringByReplacingCharactersInRange:NSMakeRange(0, length-2) withString:hideString];
            }
            break;
        }
        default:
            break;
    }
    return ret;
}

//这两个配对使用，提示用户网络问题
+ (void)addErrorViewToView:(UIView *)parentView
{
    
}
+ (void)removeErrorViewAtView:(UIView *)parentView
{
    
}

+ (void)showHudWithHint:(NSString *)hint{
//    [SVProgressHUD showWithStatus:hint];
    [MBHUDUntil showHUDToWindowWithText:hint];
}

+ (void)showHintAndDismissLater:(NSString *)hint {
    if ([hint isEqualToString:@"录音没有开始"]) {
        NSLog(@"dd");
    }
    //显示提示信息
//    [SVProgressHUD showImage:nil status:hint];
    [MBHUDUntil showHUDToWindowWithText:hint];
}

+ (void)hideHud{
//    [SVProgressHUD dismiss];
}

//对图片尺寸进行压缩--
+ (UIImage *)imageWithImage:(UIImage*)image{
    CGSize oldSize = CGSizeZero;
    if (image.size.width>300) {
        oldSize = CGSizeMake(300, 300*image.size.height/image.size.width);
    }else{
        oldSize = image.size;
    }
    // Create a graphics image context
    UIGraphicsBeginImageContext(oldSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,oldSize.width,oldSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}




+ (void)removeFooterBackgroundViewForTableView:(UITableView *)tableView{
    tableView.tableFooterView = nil;
}
//------------------------------------------------------------------------------tableview end

+ (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}
//------------------------------------------------------------------------------网络监测start
+ (BOOL)IsEnableWIFI{
    return  YES;//([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)IsEnable3G{
    return  NO;//([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

//------------------------------------------------------------------------------网络监测end



+ (NSString*)utf8WithString:(NSString *)string
{
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//四舍五入
+ (NSString *)notRounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end

/*
 字符串是否没有内容
 */
inline BOOL stringIsEmpty(NSString* str){
    BOOL ret=NO;
    if(str==nil||[str isKindOfClass:[NSNull class]]){
        ret=YES;
    }else{
        NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([temp length]<1){
            ret=YES;
        }
    }
    return ret;
}

inline NSString * strOrEmpty(NSString* str){
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return (str==nil?@"":str);
}

