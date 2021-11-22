//
//  PandroBlueToothMeshMgrOC.m
//  Pandro
//
//  Created by chun on 2019/3/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroBlueToothMeshMgrOC.h"
#import "PandroBlueToothMeshMgrBridge.h"
#import "Pandro-Swift.h"

@interface PandroBlueToothMeshMgrOC ()

@property(nonatomic, strong)PandroBlueToothMeshMgrSwift *blueToothMgrSwift;

@end

@implementation PandroBlueToothMeshMgrOC

+(PandroBlueToothMeshMgrOC *)shareInstance
{
    static PandroBlueToothMeshMgrOC *shareMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMgr = [[PandroBlueToothMeshMgrOC alloc] init];
    });
    
    return shareMgr;
}

-(id)init
{
    self = [super init];
    [PandroBlueToothMeshMgrBridge shareInstance];
    self.blueToothMgrSwift  = [[PandroBlueToothMeshMgrSwift alloc] init];
    
    self.provisionNodes = [[NSMutableArray alloc] init];
    self.unprovisionNodes = [[NSMutableArray alloc] init];
    NSLog(@"PandroBlueToothMeshMgrOC 初始化");
    return self;
}

-(void)startScan;
{
    [self.blueToothMgrSwift startScan];
}

-(void)restartScan
{
    [self.blueToothMgrSwift startScan];
}

-(void)stopScan
{
    [[PandroBlueToothMeshMgrBridge shareInstance].provisionNodes removeAllObjects];
    [[PandroBlueToothMeshMgrBridge shareInstance].unprovisionNodes removeAllObjects];

    [self.blueToothMgrSwift stopScan];
}

//开关灯带设备
- (void)onOffSetUnacknowledgedAndNum:(NSInteger)num withIson:(BOOL)isOn
{
    [self.blueToothMgrSwift onOffSetUnacknowledgedAndNumWithIndex:num onOff:isOn];
}
//设备设置 Relay
- (void)setRelayNum:(NSInteger)num withIson:(BOOL)ison
{
    [self.blueToothMgrSwift setRelayWithIndex:num onOff:ison];
}
//获取 Relay
- (void)getRelayNum:(NSInteger)num withIson:(BOOL)ison
{
    [self.blueToothMgrSwift getRelayWithIndex:num onOff:ison];
}
//获取 ProxyName
- (void)getProxyName
{
    [self.blueToothMgrSwift getProxyName];
}
//删除设备
- (void)removeDeviceNode:(NSInteger)num
{
    [self.blueToothMgrSwift removeDeviceNodeWithIndex:num];
}

- (void)removeDeviceNodelocal:(NSInteger)num
{
    [self.blueToothMgrSwift removeDeviceNodelocalWithIndex:num];
}

//控制组开关灯
- (void)setGroupOnOffSetUnacknowledgedOnOff:(BOOL)isOn withName:(NSString*)name
{
    [self.blueToothMgrSwift setGroupOnOffSetUnacknowledgedOnOff:isOn name:name];
}
//设备添加组
- (void)addDeviceGroupWithNum:(NSInteger)num WithName:(NSString *)name
{
    [self.blueToothMgrSwift addDeviceGroupWithIndex:num name:name];
}
//设备删除组
- (void)deleteDeviceGroupWithNum:(NSInteger)num WithName:(NSString *)name
{
    [self.blueToothMgrSwift deleteDeviceGroupWithIndex:num name:name];
}
//选择设备
-(void)connectMeshNode:(int)index
{
    [self.blueToothMgrSwift connectMeshNodeWithIndex:index];
}
//获取已连接设备
-(void)myDevice
{
    [self.blueToothMgrSwift myDevice];
}

-(void)connectMeshNodeArray:(NSMutableArray *)array
{
    [self.blueToothMgrSwift connectMeshNodeArrayWithIndexArray:array];
}
//添加组
- (void)setGroup:(NSString*)name
{
    [self.blueToothMgrSwift setNewGroupAndNameWithStr:name];
}
//删除组
- (void)removeGroupAndName:(NSString *)name
{
    [self.blueToothMgrSwift removeGroupAndNameWithStr:name];

}
//修改组名称
- (void)modifyGroupAndName:(NSString *)name withNewName:(NSString *)newName
{
    [self.blueToothMgrSwift modifyGroupAndNameWithStr:name newStr:newName];
}
//设置CTL
- (void)setLightCTLSet:(NSInteger)num WithTemperature:(NSInteger)temperature Withlightness:(NSInteger)lightness
{
    [self.blueToothMgrSwift setLightCTLSetWithIndex:num temperature:temperature lightness:lightness];
}
////设置HSL
- (void)setLightHSLSet:(NSInteger)num WithSaturation:(NSInteger)saturation Withlightness:(NSInteger)lightness  Withhue:(NSInteger)hue
{
    [self.blueToothMgrSwift setLightHSLSetWithIndex:num saturation:saturation lightness:lightness hue:hue];
}
//设置操作码
- (void)setNumber:(NSInteger)num WithSaturationNumber:(NSInteger)number{
    [self.blueToothMgrSwift setNumberWithIndex:num number:number];
}
-(void)provisionDeviceFinded:(CBPeripheral *)device
{
    [self.provisionNodes addObject:device];
    
    [self.delegate blueToothDevicesHasFinded];
}

-(void)unprovisionDeviceFinded:(CBPeripheral *)device
{
    [self.unprovisionNodes addObject:device];

    [self.delegate blueToothDevicesHasFinded];
}
@end
