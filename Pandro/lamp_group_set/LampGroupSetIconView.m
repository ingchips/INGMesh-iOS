//
//  LampGroupSetIconView.m
//  Pandro
//
//  Created by chun on 2019/1/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampGroupSetIconView.h"
#import "PandroEngine.h"


@interface LampGroupSetIconView ()
{
    int selectedIndex;
}

@property(nonatomic, strong)NSMutableArray *iconNameArray;
@property(nonatomic, strong)NSMutableArray *iconBtnArray;

@property(nonatomic, copy)NSString *groupIcon;

@property(nonatomic, strong)UIView *centerView;

@end

@implementation LampGroupSetIconView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame groupIcon:(NSString *)groupIcon
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    selectedIndex = -1;
    
    self.iconNameArray = [[NSMutableArray alloc] initWithObjects:@"group_set_icon_lamp", @"group_set_icon_sofa", @"group_set_icon_bed", @"group_set_icon_desk", @"group_set_icon_kitch", @"group_set_icon_dinner", @"group_set_icon_bath", @"group_set_icon_door", nil];
    
    self.iconBtnArray = [[NSMutableArray alloc] init];
    self.groupIcon = groupIcon;
    
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

-(void)clickIconBtn:(UIButton *)control
{
    int nTmp = 0;
    for (int i=0; i<self.iconBtnArray.count; i++)
    {
        UIButton *tmpControl = [self.iconBtnArray objectAtIndex:i];
        //if (i == selectedIndex)
        {
            NSString *strIcon = [self.iconNameArray objectAtIndex:i];
            //strIcon = [strIcon stringByAppendingString:@"_sel"];
            [tmpControl setImage:[UIImage loadImageWithName:strIcon] forState:UIControlStateNormal];
        }
        
        if ([tmpControl isEqual:control])
        {
            NSString *strIcon = [self.iconNameArray objectAtIndex:i];
            strIcon = [strIcon stringByAppendingString:@"_sel"];
            [tmpControl setImage:[UIImage loadImageWithName:strIcon] forState:UIControlStateNormal];
            nTmp = i;
        }
    }
    
    selectedIndex = nTmp;
    
}

-(void)clickSetIconSure:(id)sender
{
    if (selectedIndex < 0)
    {
        [self removeFromSuperview];
        return;
    }
    
    if (self.clickedBlock)
    {
        NSString *strIcon = [self.iconNameArray objectAtIndex:selectedIndex];
        strIcon = [strIcon stringByAppendingString:@"_sel"];
        
        BOOL rtn = self.clickedBlock(strIcon);
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
        CGRect rect = CGRectMake((self.frame.size.width - width)/2, 80, width, 0);
        _centerView = [[UIView alloc] initWithFrame:rect];
        _centerView.backgroundColor = [UIColor whiteColor];
        [_centerView.layer setCornerRadius:10];
        [_centerView.layer setMasksToBounds:YES];
        
        //add content
        rect = CGRectMake(0, 0, width, 40);
        UILabel *labelTip = [[UILabel alloc] initWithFrame:rect];
        labelTip.backgroundColor = [UIColor clearColor];
        labelTip.textColor = [UIColor blackPandroColor];
        labelTip.font = [UIFont systemFontOfSize:16];
        labelTip.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:labelTip];
        labelTip.text = @"选组分组图标";
        
        float topOffset = labelTip.frame.size.height;
        
        float imageViewWidth = width/4;
        float imageViewHeight = imageViewWidth - 15;
        for (int i=0; i<self.iconNameArray.count; i++)
        {
            rect = CGRectMake(imageViewWidth* (i % 4) , topOffset + (imageViewHeight) * (i/4), imageViewWidth, imageViewHeight);
            UIButton *control = [[UIButton alloc] initWithFrame:rect];
            NSString *strIcon = [self.iconNameArray objectAtIndex:i];
            //strIcon = [strIcon stringByAppendingString:@"_sel"];
            [control setImage:[UIImage loadImageWithName:strIcon] forState:UIControlStateNormal];
            
            [_centerView addSubview:control];
            
            [control addTarget:self action:@selector(clickIconBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.iconBtnArray addObject:control];
            
            /*
            control.accessibilityValue = [self.iconNameArray objectAtIndex:i];
            
            rect = CGRectMake((imageViewWidth - imageViewWidth/2)/2, (imageViewWidth - imageViewWidth/2)/2, imageViewWidth/2, imageViewWidth/2);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = [UIImage loadImageWithName:[self.iconNameArray objectAtIndex:i]];
            [control addSubview:imageView];
            
            [control addTarget:self action:@selector(clickIconBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.iconBtnArray addObject:control];
            */
        }
        
        //button
        float btnWidth = (width - 2 * 15 - 15)/2;
        topOffset = topOffset + (imageViewHeight) * (self.iconNameArray.count/4);
        topOffset = topOffset + 10;
        
        rect = CGRectMake(15, topOffset, btnWidth, 40);
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = rect;
        [cancelBtn setTitle:@"取   消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor littleBlackPandroColor] forState:UIControlStateNormal];
        [cancelBtn.layer setCornerRadius:10];
        [cancelBtn.layer setMasksToBounds:YES];
        cancelBtn.layer.borderWidth = 1;
        cancelBtn.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5].CGColor;
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
        [sureBtn addTarget:self action:@selector(clickSetIconSure:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:sureBtn];
        
        rect = _centerView.frame;
        rect.size.height = sureBtn.frame.origin.y + sureBtn.frame.size.height + 20;
        _centerView.frame = rect;
        
    }
    return _centerView;
}

@end
