//
//  UIView+PandroView.h
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (PandroView)

+(UIView *)lineView:(CGRect)rect color:(UIColor *)color;

-(void)showAnimationTip:(NSString *)tip topOffset:(float)topOffset;


-(UIViewController *)selfViewController;

@end


