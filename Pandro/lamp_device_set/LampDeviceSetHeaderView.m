//
//  LampDeviceSetHeaderView.m
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceSetHeaderView.h"
#import "PandroEngine.h"
#import "MeshPlaceDatabase.h"
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"

@interface LampDeviceSetHeaderViewButton : UIControl

@property(nonatomic, weak)LampDeviceSetHeaderView *headerView;

@property(nonatomic, strong)UIImageView *backgroundView;
@property(nonatomic, strong)UIImageView *redDotView;

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *tipLabel;

@end

@implementation LampDeviceSetHeaderViewButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.layer.shadowColor = [UIColor bluePandroColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.2;
    
    CGRect rect = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
    UIImageView *imgeView = [[UIImageView alloc] initWithFrame:rect];
    imgeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:imgeView];
    [imgeView.layer setCornerRadius:10];
    [imgeView.layer setMasksToBounds:YES];
    self.backgroundView = imgeView;
    
    rect = CGRectMake((frame.size.width - 13)/2, (frame.size.height - 13)/2, 13, 13);
    self.redDotView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.redDotView];
    self.redDotView.image = [UIImage loadImageWithName:@"lamp_device_set_color_red"];
    [self.redDotView setHidden:YES];
    
    
    rect = CGRectMake(10, 0, frame.size.width - 20, frame.size.height);
    self.titleLabel = [[UILabel alloc] initWithFrame:rect];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor bluePandroColor];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    rect = CGRectMake(0, 0, frame.size.width - 20, frame.size.height);
    self.tipLabel = [[UILabel alloc] initWithFrame:rect];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textAlignment = NSTextAlignmentRight;
    self.tipLabel.text = @"未设置";
    [self addSubview:self.tipLabel];
    
    [self addTarget:self action:@selector(clickSelfBackground:) forControlEvents:UIControlEventTouchUpInside];
    return self;

}

-(void)clickSelfBackground:(LampDeviceSetHeaderViewButton *)btn
{
    [self.headerView clickHeaderButton:self];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.backgroundView.backgroundColor = [UIColor bluePandroColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor bluePandroColor];
        
    }
}

-(float)adjustButtonWidth
{
    CGRect rect = self.titleLabel.frame;
    rect.size.width = self.frame.size.width - 20;
    self.titleLabel.frame = rect;
    
    rect = self.tipLabel.frame;
    rect.size.width = self.frame.size.width - 20;
    self.tipLabel.frame = rect;
    
    float leftOffset = 0;
    [self.titleLabel sizeToFit];
    [self.tipLabel sizeToFit];
    
    //title
    rect = self.titleLabel.frame;
    rect.origin.x = 10;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.titleLabel.frame = rect;
    
    leftOffset = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10;
    if (!self.redDotView.hidden)
    {
        //dot
        
        rect = self.redDotView.frame;
        rect.origin.x = leftOffset;
        self.redDotView.frame = rect;
        
        leftOffset = leftOffset + self.redDotView.frame.size.width + 10;
    }
    
    rect = self.tipLabel.frame;
    rect.origin.x = leftOffset;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.tipLabel.frame = rect;
    
    leftOffset = leftOffset + self.tipLabel.frame.size.width + 10;
    
    rect = self.backgroundView.frame;
    rect.size.width = leftOffset - 4;
    self.backgroundView.frame = rect;
    
    return leftOffset;
}

//0082FC

@end

@interface LampDeviceSetHeaderView ()

@property(nonatomic, strong)LampDeviceSetHeaderViewButton *allBtn;

@property(nonatomic, strong)NSMutableArray *deviceButtonArray;
@property(nonatomic, strong)NSMutableArray *deviceModelArray;

@end

@implementation LampDeviceSetHeaderView

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
    
    return self;
}

-(void)initContentUI
{
    float leftOffset = 0;
    float height = self.frame.size.height;
    float spaceOffset = 10;
    float deviceBtnWidth = 180;
    //all
    CGRect rect = CGRectMake(leftOffset, 0, 60, height-5);
    self.allBtn = [[LampDeviceSetHeaderViewButton alloc] initWithFrame:rect];
    self.allBtn.titleLabel.text = @"全部";
    [self.allBtn.tipLabel setHidden:YES];
    self.allBtn.headerView = self;
    [self addSubview:self.allBtn];
    leftOffset = leftOffset + self.allBtn.frame.size.width;
    
    //other device
    self.deviceButtonArray = [[NSMutableArray alloc] init];
    
    MeshPlaceModel *placeModel = [[MeshPlaceDatabase shareInstance] placeModelFromPlaceId:self.placeId];
    MeshAreaModel *areaModel = nil;
    for (MeshAreaModel *areaModelTmp in placeModel.areaArray)
    {
        if ([areaModelTmp.areaId isEqualToString:self.areaId])
        {
            areaModel = areaModelTmp;
            break;
        }
    }
    self.deviceModelArray = areaModel.deviceArray;
    
    int index = 0;
    for (MeshDeviceModel *deviceModel in areaModel.deviceArray)
    {
        leftOffset = leftOffset + spaceOffset;
        rect = CGRectMake(leftOffset, 0, deviceBtnWidth, height-5);
        
        LampDeviceSetHeaderViewButton *deviceBtn = [[LampDeviceSetHeaderViewButton alloc] initWithFrame:rect];
        [self addSubview:deviceBtn];
        deviceBtn.titleLabel.text = deviceModel.name;
        deviceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        rect = deviceBtn.titleLabel.frame;
        rect.origin.x = 20;
        deviceBtn.titleLabel.frame = rect;
        deviceBtn.headerView = self;
        
        
        [self.deviceButtonArray addObject:deviceBtn];
        
        if (index == 1)
        {
            [deviceBtn.redDotView setHidden:NO];
            deviceBtn.tipLabel.text = @"按键1,按键2";
        }
        
        
        leftOffset = leftOffset + deviceBtnWidth;
        
        index++;
    }
    
    if (leftOffset > self.frame.size.width)
    {
        self.contentSize = CGSizeMake(leftOffset, self.frame.size.height);
    }
    
    [self adjustAllBtnSize];
    
}

-(void)adjustAllBtnSize
{
    float spaceOffset = 10;
    float leftOffset = self.allBtn.frame.size.width + spaceOffset;
    
    
    for (LampDeviceSetHeaderViewButton *deviceBtn in self.deviceButtonArray)
    {
        float btnTmpWidht = [deviceBtn adjustButtonWidth];
        CGRect rect = deviceBtn.frame;
        rect.origin.x = leftOffset;
        rect.size.width = btnTmpWidht;
        deviceBtn.frame = rect;
        
        leftOffset = leftOffset + btnTmpWidht;
        leftOffset = leftOffset + spaceOffset;
        
    }
    
    if (leftOffset > self.frame.size.width)
    {
        self.contentSize = CGSizeMake(leftOffset, self.frame.size.height);
    }
}


#pragma mark fun
-(void)clickHeaderButton:(LampDeviceSetHeaderViewButton *)btn
{
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    [array addObject:self.allBtn];
    [array addObjectsFromArray:self.deviceButtonArray];
    
    for (LampDeviceSetHeaderViewButton *button in array)
    {
        if ([button isEqual:btn])
        {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
}
@end
