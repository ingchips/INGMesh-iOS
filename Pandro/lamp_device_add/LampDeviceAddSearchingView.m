//
//  LampDeviceAddSearchingView.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddSearchingView.h"
#import "PandroEngine.h"

@implementation LampDeviceAddSearchingView

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
    float topOffset = 160;
    float width = 135;
    CGRect rect = CGRectMake((self.frame.size.width-width)/2, topOffset, width, width);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = [UIImage loadImageWithName:@"device_list_searching"];
    [self addSubview:imgView];
    
    //tip
    topOffset = topOffset + width + 75;
    rect = CGRectMake(0, topOffset, self.frame.size.width, 20);
    UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = [UIColor bluePandroColor];
    labelTip.font = [UIFont systemFontOfSize:16];
    labelTip.text = @"正在搜索设备…";
    labelTip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTip];
    
    
    return self;
}

@end
