//
//  UIImage+PandroImage.m
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "UIImage+PandroImage.h"

@implementation UIImage (PandroImage)

+(UIImage *)loadImageWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    path = [path stringByAppendingPathComponent:@"resource.bundle"];
    NSString *imagePath = [path stringByAppendingPathComponent:name];
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    return image;
}
@end
