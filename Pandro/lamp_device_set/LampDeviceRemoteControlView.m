//
//  LampDeviceRemoteControlView.m
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceRemoteControlView.h"
#import "PandroEngine.h"

@interface LampDeviceRemoteControlView ()
{
    
}

@property(nonatomic, strong)UIView *centerView;

@end

@implementation LampDeviceRemoteControlView

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
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    [self addSubview:self.centerView];
    [self addTarget:self action:@selector(clickBackground) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
    
}

#pragma mark fun
-(void)clickBackground
{
    [self removeFromSuperview];
}
-(void)clickSetRemoteControl
{
    
    if (self.clickedBlock)
    {
        BOOL rtn = self.clickedBlock(@" ");
        if (rtn)
        {
            [self removeFromSuperview];
        }
    }
}

-(void)clickControlBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

#pragma mark getter and setter
-(UIView *)centerView
{
    if (!_centerView)
    {
        float width = self.frame.size.width - 100;
        CGRect rect = CGRectMake((self.frame.size.width - width)/2, 100, width, 230);
        _centerView = [[UIView alloc] initWithFrame:rect];
        _centerView.backgroundColor = [UIColor whiteColor];
        [_centerView.layer setCornerRadius:10];
        [_centerView.layer setMasksToBounds:YES];
        
        //add content
        rect = CGRectMake(0, 0, width, 60);
        UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
        labelTip.backgroundColor = [UIColor clearColor];
        labelTip.textColor = [UIColor blackPandroColor];
        labelTip.font = [UIFont systemFontOfSize:18];
        labelTip.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:labelTip];
        labelTip.text = @"选择遥控器按键";
        
        
        //line
        rect = CGRectMake(0, labelTip.frame.size.height, width, 0.5);
        UIView *lineView = [[UIView alloc] initWithFrame:rect];
        lineView.backgroundColor = [UIColor littleBlackPandroColor];
        lineView.alpha = 0.3;
        //[_centerView addSubview:lineView];
        
        float topOffset = labelTip.frame.size.height + labelTip.frame.origin.y + 5;
        float leftOffset = (_centerView.frame.size.width - 30* 4)/5;
        for (int i=0; i<4; i++)
        {
            rect = CGRectMake(leftOffset + (leftOffset + 30)*i, topOffset, 30, 80);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            
            //[btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"B8C0D1FF"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0082FCFF"] forState:UIControlStateSelected];
            
            [btn setImage:[UIImage loadImageWithName:@"lamp_device_set_control_off"] forState:UIControlStateNormal];
            [btn setImage:[UIImage loadImageWithName:@"lamp_device_set_control_on"] forState:UIControlStateSelected];
            
            UILabel *titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 80)];
            titleLabe.backgroundColor = [UIColor clearColor];
            titleLabe.font = [UIFont systemFontOfSize:15];
            titleLabe.textColor = [UIColor colorWithHexString:@"B8C0D1FF"];
            titleLabe.textAlignment = NSTextAlignmentCenter;
            titleLabe.text = [NSString stringWithFormat:@"%d", i+1];
            [btn addSubview:titleLabe];
            
            btn.tag = 2000 + i;
            [_centerView addSubview:btn];
            [btn addTarget:self action:@selector(clickControlBtn:) forControlEvents:UIControlEventTouchUpInside];
        }

        
        //button
        float btnWidth = (width - 2 * 15 - 15)/2;
        topOffset = _centerView.frame.size.height - 60;
        rect = CGRectMake(15, topOffset, btnWidth, 40);
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = rect;
        [cancelBtn setTitle:@"取   消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor littleBlackPandroColor] forState:UIControlStateNormal];
        [cancelBtn.layer setCornerRadius:10];
        [cancelBtn.layer setMasksToBounds:YES];
        cancelBtn.layer.borderWidth = 1;
        cancelBtn.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5].CGColor;
        [cancelBtn addTarget:self action:@selector(clickBackground) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:cancelBtn];
        
        rect.origin.x = cancelBtn.frame.origin.x + cancelBtn.frame.size.width + 15;
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureBtn.frame = rect;
        [sureBtn setTitle:@"确   定" forState:UIControlStateNormal];
        //[sureBtn setTitleColor:[UIColor littleBlackPandroColor] forState:UIControlStateNormal];
        [sureBtn.layer setCornerRadius:10];
        [sureBtn.layer setMasksToBounds:YES];
        sureBtn.layer.borderWidth = 1;
        sureBtn.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5].CGColor;
        [sureBtn addTarget:self action:@selector(clickSetRemoteControl) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:sureBtn];
        
        
        rect = _centerView.frame;
        rect.size.height = sureBtn.frame.origin.y + sureBtn.frame.size.height + 20;
        //_centerView.frame = rect;
        
    }
    return _centerView;
}

@end
