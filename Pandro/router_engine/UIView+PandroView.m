//
//  UIView+PandroView.m
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "UIView+PandroView.h"

@implementation UIView (PandroView)

+(UIView *)lineView:(CGRect)rect color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    return view;
}

-(void)showAnimationTip:(NSString *)tip topOffset:(float)topOffset
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = tip;
    [label sizeToFit];
    
    CGSize size = label.frame.size;
    
    size = CGSizeMake(size.width + 20, size.height + 10);
    float offsetTmp = topOffset;
    if (topOffset < 1)
    {
        offsetTmp = 150;
    }
    
    
    CGRect rect = CGRectMake((self.frame.size.width - size.width ) /2, offsetTmp, size.width, size.height);
    UIView *tmpView = [[UIView alloc] initWithFrame:rect];
    tmpView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [tmpView.layer setCornerRadius:5];
    [tmpView.layer setMasksToBounds:YES];
    
    label.frame = CGRectMake(0, 0, size.width, size.height);
    [tmpView addSubview:label];

    [self addSubview:tmpView];
    
    
    [UIView animateWithDuration:2 animations:^{
        //
        tmpView.alpha = 0;
    } completion:^(BOOL finished) {
        //
        [tmpView removeFromSuperview];
    }];
}

-(UIViewController *)selfViewController
{
    UIViewController *viewController = nil;
    UIResponder *responder = self.nextResponder;
    while (responder)
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return responder;
        }
        responder = responder.nextResponder;
    }
    
    return viewController;
}
@end
