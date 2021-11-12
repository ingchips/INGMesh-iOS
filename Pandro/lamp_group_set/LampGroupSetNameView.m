//
//  LampGroupSetNameView.m
//  Pandro
//
//  Created by chun on 2019/1/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampGroupSetNameView.h"
#import "PandroEngine.h"


@interface LampGroupSetNameView ()
{
    
}

@property(nonatomic, copy)NSString *groupName;
@property(nonatomic, strong)UIView *centerView;

@end

@implementation LampGroupSetNameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame groupName:(NSString *)groupName
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    self.groupName = groupName;
    
    [self addSubview:self.centerView];
    [self addTarget:self action:@selector(clickBackground) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
    
    
}
-(void)dealloc
{
    
}

-(void)clickBackground
{
    [self removeFromSuperview];
}

-(void)clickSetName
{
    /*
    if (self.textField.text.length == 0 || [self.textField.text isEqualToString:self.groupName])
    {
        [self removeFromSuperview];
        return;
    }
    */
    
    if (self.clickedBlock)
    {
        BOOL rtn = self.clickedBlock(self.textField.text);
        if (rtn)
        {
            [self removeFromSuperview];
        }
    }
}

#pragma mark getter and setter
-(UIView *)centerView
{
    if (!_centerView)
    {
        float width = self.frame.size.width - 100;
        CGRect rect = CGRectMake((self.frame.size.width - width)/2, 100, width, 0);
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
        labelTip.text = @"输入群组名称";
        self.nameTipLabel = labelTip;
        
        //line
        rect = CGRectMake(0, labelTip.frame.size.height, width, 0.5);
        UIView *lineView = [[UIView alloc] initWithFrame:rect];
        lineView.backgroundColor = [UIColor littleBlackPandroColor];
        lineView.alpha = 0.3;
        //[_centerView addSubview:lineView];
        
        //text
        rect = CGRectMake(15, labelTip.frame.size.height, width - 30, 40);
        self.textField = [[UITextField alloc] initWithFrame:rect];
        [_centerView addSubview:self.textField];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.placeholder = self.groupName;
        
        //button
        float btnWidth = (width - 2 * 15 - 15)/2;
        rect = CGRectMake(15, self.textField.frame.origin.y + self.textField.frame.size.height + 20, btnWidth, 40);
        
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
        [sureBtn addTarget:self action:@selector(clickSetName) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:sureBtn];
        
        rect = _centerView.frame;
        rect.size.height = sureBtn.frame.origin.y + sureBtn.frame.size.height + 20;
        _centerView.frame = rect;
        
    }
    return _centerView;
}

@end
