//
//  MBHUDUntil.h
//  HUD
//
//  Created by choice-ios1 on 15/7/13.
//  Copyright (c) 2015年 choice-ios1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//统一的控制是否显示动画的变量，默认YES
extern BOOL MBHUDAnimated;

@class MBProgressHUD;

@interface MBHUDUntil : NSObject

/*
 common
 */
// show a default hud with UIActivityIndicatorView
+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view;

// show a hud with UIActivityIndicatorView and text
+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view WithText:(NSString*)str;

// hide hud
+ (BOOL)hideHUDForView:(UIView *)view;

+ (NSUInteger)hideAllHUDForView:(UIView*)view;

/*
 diy
 */
// show a custom hud and hidden a little bit
+ (MBProgressHUD*)showSucessHUDAddedTo:(UIView *)view WithText:(NSString*)str;

+ (MBProgressHUD*)showFailHUDAddedTo:(UIView *)view WithText:(NSString*)str;

// show a hud only with text and hidden a little bit
+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view OnlyText:(NSString*)str;

+ (MBProgressHUD*)showHUDToWindowWithText:(NSString*)str;

@end
