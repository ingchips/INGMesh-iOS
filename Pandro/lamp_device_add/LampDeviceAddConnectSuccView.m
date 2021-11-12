//
//  LampDeviceAddConnectSuccView.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddConnectSuccView.h"
#import "PandroEngine.h"

@implementation LampDeviceAddConnectSuccView

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
    float width = 225;  //450 * 266
    CGRect rect = CGRectMake((self.frame.size.width-width)/2, topOffset, width, 133);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = [UIImage loadImageWithName:@"device_list_connectsucceed"];
    [self addSubview:imgView];
    
    //tip
    topOffset = imgView.frame.origin.y + imgView.frame.size.height + 40;
    rect = CGRectMake(0, topOffset, self.frame.size.width, 22);
    UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = [UIColor blackPandroColor];
    labelTip.font = [UIFont systemFontOfSize:20];
    labelTip.text = @"接入成功";
    labelTip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTip];
    
    
    return self;
}

@end
