//
//  LampDeviceAddConnectFailView.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddConnectFailView.h"
#import "PandroEngine.h"
#import "LampDeviceAddViewController.h"

@implementation LampDeviceAddConnectFailView

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
    float topOffset = 110;
    float width = 225;
    CGRect rect = CGRectMake((self.frame.size.width-width)/2, topOffset, width, 133);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = [UIImage loadImageWithName:@"device_list_connectfail"];
    [self addSubview:imgView];
    
    //tip
    
    {
        
        topOffset = self.frame.size.height - 320;
        rect = CGRectMake(0, topOffset, self.frame.size.width, 22);
        UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
        labelTip.backgroundColor = [UIColor clearColor];
        labelTip.textColor = [UIColor blackPandroColor];
        labelTip.font = [UIFont systemFontOfSize:20];
        labelTip.text = @"接入失败";
        labelTip.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelTip];
        
        topOffset = topOffset + 50;
        rect = CGRectMake(100, topOffset, self.frame.size.width-100, 15);
        labelTip = [[UILabel alloc] initWithFrame:rect];
        labelTip.backgroundColor = [UIColor clearColor];
        labelTip.textColor = [UIColor blackPandroColor];
        labelTip.alpha = 0.6;
        labelTip.font = [UIFont systemFontOfSize:13];
        labelTip.text = @"可能的原因";
        [self addSubview:labelTip];
        
        topOffset = topOffset + 30;
        rect = CGRectMake(100, topOffset, self.frame.size.width-100, 70);
        labelTip = [[UILabel alloc] initWithFrame:rect];
        labelTip.backgroundColor = [UIColor clearColor];
        labelTip.textColor = [UIColor blackPandroColor];
        labelTip.font = [UIFont systemFontOfSize:13];
        labelTip.text = @"1.设备断电\r\n2.设备与手机距离太远\r\n3.设备已退出配对状态";
        labelTip.numberOfLines = 0;
        [self addSubview:labelTip];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelTip.text];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10.0;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, attributedString.length)];
        
        labelTip.attributedText = attributedString;
        
    }
    
    
    //button
    topOffset = self.frame.size.height - 110;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, topOffset, self.frame.size.width - 60, 48);
    [btn setBackgroundColor:[UIColor bluePandroColor]];
    [btn setTitle:@"重试" forState:UIControlStateNormal];
    [btn.layer setCornerRadius:10];
    [btn.layer setMasksToBounds:YES];
    [btn addTarget:self action:@selector(clickTryConnectAgain:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return self;
}

-(void)clickTryConnectAgain:(id)sender
{
    LampDeviceAddViewController *viewCon = [self selfViewController];
    [viewCon clickTryConnectAgain:sender];
}
@end
