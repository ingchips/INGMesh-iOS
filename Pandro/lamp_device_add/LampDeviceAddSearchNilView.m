//
//  LampDeviceAddSearchNilView.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddSearchNilView.h"
#import "PandroEngine.h"
#import "LampDeviceAddViewController.h"


@implementation LampDeviceAddSearchNilView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    //imageView
    float topOffset = 140;
    float width = 150;
    CGRect rect = CGRectMake((self.frame.size.width-width)/2, topOffset, width, width);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = [UIImage loadImageWithName:@"device_list_searchnil"];
    [self addSubview:imgView];
    
    //tip
    topOffset = topOffset + width + 80;
    rect = CGRectMake(0, topOffset, self.frame.size.width, 22);
    UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = [UIColor colorWithRed:43.0/255.0 green:56.0/255.0 blue:82.0/255.0 alpha:1];
    labelTip.font = [UIFont systemFontOfSize:20];
    labelTip.text = @"未发现附近设备";
    labelTip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTip];
    
    topOffset = topOffset + 30;
    rect = CGRectMake(0, topOffset, self.frame.size.width, 22);
    labelTip = [[UILabel alloc] initWithFrame:rect];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = [UIColor colorWithRed:115.0/255.0 green:131.0/255.0 blue:162.0/255.0 alpha:1];
    labelTip.font = [UIFont systemFontOfSize:14];
    labelTip.text = @"请确认设备已处于被发现状态";
    labelTip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTip];
    
    //button
    topOffset = topOffset + 100;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, topOffset, self.frame.size.width - 60, 48);
    [btn setBackgroundColor:[UIColor bluePandroColor]];
    [btn setTitle:@"重试" forState:UIControlStateNormal];
    [btn.layer setCornerRadius:10];
    [btn.layer setMasksToBounds:YES];
    [btn addTarget:self action:@selector(clickTrySearchAgain:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return self;
}

-(void)clickTrySearchAgain:(id)sender
{
    LampDeviceAddViewController *viewCon = [self selfViewController];
    [viewCon clickTrySearchAgain:sender];
}

@end
