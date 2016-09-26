//
//  MBHUDUntil.m
//  HUD
//
//  Created by choice-ios1 on 15/7/13.
//  Copyright (c) 2015年 choice-ios1. All rights reserved.
//

#import "MBHUDUntil.h"
#import "MBProgressHUD.h"

BOOL MBHUDAnimated = YES;

@implementation MBHUDUntil


+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view
{
    MBProgressHUD * hud = [self showHUDAddedTo:view WithText:@""];
    return hud;
}
+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view WithText:(NSString*)str
{
    [MBProgressHUD hideAllHUDsForView:view animated:MBHUDAnimated];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:MBHUDAnimated];
    hud.labelText = str;
    return hud;
}
+ (BOOL)hideHUDForView:(UIView *)view
{
    BOOL isHide = [MBProgressHUD hideHUDForView:view animated:MBHUDAnimated];
    
    return isHide;
}
+ (NSUInteger)hideAllHUDForView:(UIView*)view
{
    NSUInteger count = [MBProgressHUD hideAllHUDsForView:view animated:MBHUDAnimated];
    return count;
}
// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
+ (MBProgressHUD*)showSucessHUDAddedTo:(UIView *)view WithText:(NSString*)str{
    
    MBProgressHUD * hud = [self showHUDAddedTo:view WithText:str AndImage:[UIImage imageNamed:@"37x-Checkmark"]];
    return hud;
}
+ (MBProgressHUD*)showFailHUDAddedTo:(UIView *)view WithText:(NSString*)str
{
    
    MBProgressHUD * hud = [self showHUDAddedTo:view WithText:str AndImage:[UIImage imageNamed:@"37x-Forkmark"]];
    return hud;
}

+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view OnlyText:(NSString*)str
{
    MBProgressHUD * hud = [self showHUDAddedTo:view WithText:str AndImage:nil];
    return hud;
}
+ (MBProgressHUD*)showHUDToWindowWithText:(NSString*)str
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithWindow:window];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"提示";
    hud.detailsLabelText = str;
    [window addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    return hud;
}
// privately method
+ (MBProgressHUD*)showHUDAddedTo:(UIView *)view WithText:(NSString*)str AndImage:(UIImage*)image
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:MBHUDAnimated];
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = str;
    if (image==nil) {
        hud.mode = MBProgressHUDModeText;
    }else{
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    [hud hide:YES afterDelay:1];
    return hud;
}

@end
