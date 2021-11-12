//
//  UIColor+PandroColor.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "UIColor+PandroColor.h"

@implementation UIColor (PandroColor)

+(UIColor *)whitePandroColor
{
    return [UIColor whiteColor];
}
+(UIColor *)blackPandroColor
{
    return [UIColor colorWithRed:43.0/255.0 green:56.0/255.0 blue:82.0/255.0 alpha:1];
}
+(UIColor *)secondBlackPandroColor
{
    return [UIColor colorWithRed:25/255.0 green:35/255.0 blue:45/255.0 alpha:1];
}
+(UIColor *)littleBlackPandroColor
{
    return [UIColor colorWithRed:34.0/255.0 green:47.0/255.0 blue:58.0/255.0 alpha:1];
}
+(UIColor *)grayPandroColor
{
    return [UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1];
}
+(UIColor *)littleGrayPandroColor
{
    return [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1];
}
+(UIColor *)bluePandroColor
{
    return [UIColor colorWithRed:0/255.0 green:130.0/255.0 blue:251.0/255.0 alpha:1];
}

+(UIColor *)colorWithHexString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if(NO == flag)
        return [UIColor clearColor];
    float r, g, b, a;
    a = (value & 0x000000FF) / 255.0;
    value = value >> 8;
    b = value & 0x000000FF;
    value = value >> 8;
    g = value & 0x000000FF;
    value = value >> 8;
    r = value;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

@end
