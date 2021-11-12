//
//  PandroNavBarView.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "PandroNavBarView.h"
#import "UIColor+PandroColor.h"
#import "UIImage+PandroImage.h"

@implementation PandroNavBarView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.backgroundImgView];
    
    [self addSubview:self.titlelabel];
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor blackColor];
        //[self addSubview:lineView];
    }
    return self;
}

#pragma mark getter
-(UIImageView *)backgroundImgView
{
    if (!_backgroundImgView)
    {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _backgroundImgView = [[UIImageView alloc] initWithFrame:rect];
        _backgroundImgView.image = [UIImage loadImageWithName:@"app_nav_bar_bg"];
    }
    return _backgroundImgView;
}

-(UILabel *)titlelabel
{
    if (!_titlelabel)
    {
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.frame.size.height - 44, self.frame.size.width-80, 44)];
        _titlelabel.backgroundColor = [UIColor clearColor];
        _titlelabel.font = [UIFont boldSystemFontOfSize:16];
        _titlelabel.textColor = [UIColor whitePandroColor];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}
-(UIButton *)leftBtn
{
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
        
        _leftBtn.frame = CGRectMake(10, self.frame.size.height - 30 - 7, 30, 30);
        [self addSubview:_leftBtn];
        
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
        
        _rightBtn.frame = CGRectMake(self.frame.size.width - 30 - 10, self.frame.size.height - 30 - 7, 30, 30);
        [self addSubview:_rightBtn];
    }
    
    return _rightBtn;
}

@end
