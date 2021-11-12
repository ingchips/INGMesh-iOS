//
//  LampMeshGroupCell.m
//  Pandro
//
//  Created by chun on 2019/3/1.
//  Copyright 漏 2019骞?chun. All rights reserved.
//

#import "LampMeshGroupCell.h"
#import "PandroEngine.h"
#import "PandroBlueToothMeshMgrOC.h"
#import "PandroBlueToothMeshMgrBridge.h"


@interface LampMeshGroupCell ()

@property(nonatomic, strong)LampMeshViewGroupModel *groupModel;

@property(nonatomic, strong)UIImageView *arrowImgView;
@property(nonatomic, strong)UIImageView *iconImgView;

@property(nonatomic, strong)UIButton *settingBtn;
@property(nonatomic, strong)UIButton *addBtn;

@property(nonatomic, strong)UIButton *switchBtn;



@property(nonatomic, strong)UILabel *groupNameLabel;
@property(nonatomic, strong)UILabel *groupTipLabel;

@end

@implementation LampMeshGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.settingBtn];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.switchBtn];

    
    [self.contentView addSubview:self.groupNameLabel];
    [self.contentView addSubview:self.groupTipLabel];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //icon
    {
        CGRect rect = self.iconImgView.frame;
        rect.origin.x = 10;
        rect.origin.y = (self.frame.size.height - rect.size.height)/2;
        self.iconImgView.frame = rect;
    }
    
    //arrow
    {
        CGRect rect = self.arrowImgView.frame;
        rect.origin.x = self.frame.size.width - rect.size.width - 10;
        rect.origin.y = (self.frame.size.height - rect.size.height)/2;
        self.arrowImgView.frame = rect;
    }
    
    float leftOffset = self.arrowImgView.frame.origin.x ;
    self.settingBtn.frame = CGRectMake(leftOffset - 40 -15, 0, 40, self.frame.size.height);
    
    

    
    CGRect rect = self.addBtn.frame;
    rect.origin.x = leftOffset - 40 - 15;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.addBtn.frame = rect;
    
    
    float leftSwitchOffset = self.settingBtn.frame.origin.x - 85;
    self.switchBtn.frame = CGRectMake(leftSwitchOffset, (self.frame.size.height - 42)/2, 55, 42);


    leftOffset = self.iconImgView.frame.origin.x + self.iconImgView.frame.size.width + 10;
    float rightOffset = self.settingBtn.frame.origin.x;

    self.groupNameLabel.frame = CGRectMake(leftOffset, self.frame.size.height/2 - 18, rightOffset - leftOffset, 18);
    self.groupTipLabel.frame = CGRectMake(leftOffset, self.frame.size.height/2, rightOffset - leftOffset, 20);
    
}
#pragma mark fun
-(void)showContentFromModule:(LampMeshViewGroupModel *)module
{
    self.groupModel = module;
    
    if (self.groupModel.allDeviceGroup)
    {
        [self.settingBtn setHidden:YES];
        [self.addBtn setHidden:NO];
        self.groupNameLabel.text = @"全部设备";
        
        self.iconImgView.image = [UIImage loadImageWithName:@"group_set_icon_device_sel"];
        self.groupNameLabel.text = [NSString stringWithFormat:@"%@(%ld个设备)",self.groupNameLabel.text,self.groupModel.deviceArray.count];
        if (self.nameStr && [self.nameStr isKindOfClass:[NSString class]] && self.nameStr.length > 0) {
            self.groupTipLabel.text = [NSString stringWithFormat:@"现在链接的设备(%@)", self.nameStr];
        }else{
            self.groupTipLabel.text = @"获取链接设备中...";
        }

    }
    else
    {
        [self.settingBtn setHidden:NO];
        [self.addBtn setHidden:YES];
        self.groupNameLabel.text = self.groupModel.areaModel.name;
        NSString *icon = self.groupModel.areaModel.iconName;
        self.groupTipLabel.text = [NSString stringWithFormat:@"%ld个设备", self.groupModel.deviceArray.count];
        if (icon)
        {
            self.iconImgView.image = [UIImage loadImageWithName:icon];
        }
        else
        {
            self.iconImgView.image = [UIImage loadImageWithName:@"group_set_icon_device_sel"];
        }
    }
//    self.groupNameLabel.text = [NSString stringWithFormat:@"%@(%d涓澶?",self.groupNameLabel.text,self.groupModel.deviceArray.count];
    
    //arror
    if (self.groupModel.showExpand)
    {
        self.arrowImgView.image = [UIImage loadImageWithName:@"lamp_mesh_cell_down"];
    }
    else
    {
        self.arrowImgView.image = [UIImage loadImageWithName:@"lamp_mesh_cell_up"];
    }
    
    if (self.groupModel.isOn)
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
    }
}

-(void)clickSettingGroup:(UIButton *)btn
{
    PandroSuperViewController *viewCon = [self selfViewController];

    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
    [dictItem setValue:self.placeId forKey:@"placeId"];
    [dictItem setValue:self.groupModel.areaModel.areaId forKey:@"areaId"];
    [viewCon gotoPage:PAGE_LAME_GROUP_SET_VC params:dictItem command:@"init"];
}
- (void)addBtnDown
{
        PandroSuperViewController *viewCon = [self selfViewController];
       [viewCon gotoPage:PAGE_LAME_DEVICE_ADD_VC params:nil command:@"init"];
}
-(void)clickSwitchBtn
{
    if ([PandroBlueToothMeshMgrBridge shareInstance].myDeviceArr.count < 1) {
        [self showAnimationTip:@"没有已经入网的设备，请添加设备后操作" topOffset:0];
        return;
    }
    self.groupModel.isOn = !self.groupModel.isOn;
    NSString *name = self.groupModel.areaModel.name;
    if (self.groupModel.allDeviceGroup) {
        name =@"全部设备开关灯";
    }
   
    if (self.groupModel.isOn)
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_on"] forState:UIControlStateNormal];
        [[PandroBlueToothMeshMgrOC shareInstance] setGroupOnOffSetUnacknowledgedOnOff:YES withName:name];
    }
    else
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
        [[PandroBlueToothMeshMgrOC shareInstance] setGroupOnOffSetUnacknowledgedOnOff:NO withName:name];
    }
    
    if (self.lampMeshGroupDeviceCellDelegate ) {
        [self.lampMeshGroupDeviceCellDelegate selectedGroupItemButton:self.indexPath];
    }
}
#pragma mark getter and setter
-(UIImageView *)arrowImgView
{
    if (!_arrowImgView)
    {
        //24 14
        CGRect rect = CGRectMake(0, 0, 12, 7);
        _arrowImgView = [[UIImageView alloc] initWithFrame:rect];
        _arrowImgView.image = [UIImage loadImageWithName:@"lamp_mesh_cell_up"];
    }
    return _arrowImgView;
}

-(UIImageView *)iconImgView
{
    if (!_iconImgView)
    {
        //24 14
        CGRect rect = CGRectMake(0, 0, 35, 35);
        _iconImgView = [[UIImageView alloc] initWithFrame:rect];
        _iconImgView.image = [UIImage loadImageWithName:@"group_set_icon_device_sel"];
    }
    return _iconImgView;
}

-(UIButton *)settingBtn
{
    if (!_settingBtn)
    {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_set"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(clickSettingGroup:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}
-(UIButton *)addBtn
{
    if (!_addBtn)
    {
        CGRect rect = CGRectMake(0, 0, 35,35);
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = rect;//group_set_icon_device_sel  group_set_icon_set_device
        [_addBtn setImage:[UIImage loadImageWithName:@"group_set_icon_set_device"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
-(UILabel *)groupNameLabel
{
    if (!_groupNameLabel)
    {
        _groupNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupNameLabel.backgroundColor = [UIColor clearColor];
        _groupNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _groupNameLabel.textColor = [UIColor blackPandroColor];
    }
    return _groupNameLabel;
}

-(UILabel *)groupTipLabel
{
    if (!_groupTipLabel)
    {
        _groupTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupTipLabel.backgroundColor = [UIColor clearColor];
        _groupTipLabel.font = [UIFont systemFontOfSize:12];
        _groupTipLabel.textColor = [UIColor colorWithHexString:@"D8D8D8FF"];
    }
    return _groupTipLabel;
}
-(UIButton *)switchBtn
{
    if (!_switchBtn)
    {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}
@end


