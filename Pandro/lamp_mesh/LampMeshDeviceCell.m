//
//  LampMeshDeviceCell.m
//  Pandro
//
//  Created by chun on 2019/3/1.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampMeshDeviceCell.h"
#import "PandroEngine.h"
#import "PandroBlueToothMeshMgrOC.h"
#import "PandroBlueToothMeshMgrBridge.h"
#import "UIButton+SolveContinuousClick.h"

@interface LampMeshDeviceCell ()

@property(nonatomic, strong)MeshDeviceModel *deviceModel;

@property(nonatomic, strong)UILabel *deviceNameLabel;
@property(nonatomic, strong)UILabel *deviceIdLabel;

@property(nonatomic, strong)UIButton *switchBtn;

@end

@implementation LampMeshDeviceCell

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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.deviceNameLabel];
    [self.contentView  addSubview:self.deviceIdLabel];
    [self.contentView  addSubview:self.switchBtn];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.deviceNameLabel.frame = CGRectMake(15, 5, self.frame.size.width - 30, self.frame.size.height/3);
    self.deviceIdLabel.frame = CGRectMake(15, self.frame.size.height/2, self.frame.size.width - 30, self.frame.size.height/3);
    float rightOffset = self.frame.size.width - 55 - 40;
    self.switchBtn.frame = CGRectMake(rightOffset, (self.frame.size.height - 42)/2, 55, 42);
}
#pragma mark fun

-(void)showContentFromModule:(MeshDeviceModel *)deviceModel
{
    self.deviceModel = deviceModel;
    self.deviceNameLabel.text = deviceModel.name;
    self.deviceIdLabel.text = deviceModel.deviceId;
    
    if (self.deviceModel.switchOn)
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
    }
    
    if (self.nameStr && [self.nameStr isKindOfClass:[NSString class]] && self.nameStr.length > 0 && [self.nameStr isEqualToString:deviceModel.name]  && ![self.nameStr isEqualToString:@"Unknown Device"]) {
        self.deviceNameLabel.textColor = [UIColor redColor];
        self.deviceIdLabel.textColor = [UIColor redColor];
    }
    else{
        self.deviceNameLabel.textColor = [UIColor blackPandroColor];
        self.deviceIdLabel.textColor = [UIColor blackPandroColor];
    }
}

-(void)clickSwitchBtn
{
    if([PandroBlueToothMeshMgrBridge shareInstance].myDeviceArr.count<1){
        [self showAnimationTip:@"没有已经入网的设备，请添加设备后操作" topOffset:0];
        return;
    }
    self.deviceModel.switchOn = !self.deviceModel.switchOn;
    
    NSInteger number = 0;
    for (MeshDeviceModel *deviceModel in self.placeModel.deviceArray)
    {
        if ([self.deviceModel.deviceId isEqualToString:deviceModel.deviceId]) {
            break;
        }
        number++;
    }
    if (self.deviceModel.switchOn)
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_on"] forState:UIControlStateNormal];
        [[PandroBlueToothMeshMgrOC shareInstance] onOffSetUnacknowledgedAndNum:number withIson:YES];
    }
    else
    {
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
        [[PandroBlueToothMeshMgrOC shareInstance] onOffSetUnacknowledgedAndNum:number withIson:NO];
    }
    if (self.lampMeshDeviceCellDelegate ) {
        [self.lampMeshDeviceCellDelegate selectedItemButton:self.indexPath];
    }
}

#pragma mark getter and setter
-(UILabel *)deviceNameLabel
{
    if (!_deviceNameLabel)
    {
        _deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceNameLabel.backgroundColor = [UIColor clearColor];
        _deviceNameLabel.font = [UIFont systemFontOfSize:15];
        _deviceNameLabel.textColor = [UIColor blackPandroColor];
    }
    return _deviceNameLabel;
}
-(UILabel *)deviceIdLabel
{
    if (!_deviceIdLabel)
    {
        _deviceIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceIdLabel.backgroundColor = [UIColor clearColor];
        _deviceIdLabel.font = [UIFont systemFontOfSize:10];
        _deviceIdLabel.textColor = [UIColor blackPandroColor];
    }
    return _deviceIdLabel;
}
-(UIButton *)switchBtn
{
    if (!_switchBtn)
    {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_cell_switch_off"] forState:UIControlStateNormal];
        _switchBtn.scc_custom_acceptEventInterval = 1.0;//防止点击两次
        [_switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}
@end
