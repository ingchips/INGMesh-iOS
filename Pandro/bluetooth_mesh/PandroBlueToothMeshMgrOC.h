//
//  PandroBlueToothMeshMgrOC.h
//  Pandro
//
//  Created by chun on 2019/3/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBlueTooth/CoreBlueTooth.h>


@protocol PandroBlueToothMeshMgrOCDelegate <NSObject>

-(void)blueToothDevicesHasFinded;

@end

@interface PandroBlueToothMeshMgrOC : NSObject

@property(nonatomic, strong)NSMutableArray *provisionNodes;
@property(nonatomic, strong)NSMutableArray *unprovisionNodes;

@property(nonatomic, weak)id<PandroBlueToothMeshMgrOCDelegate> delegate;

+(PandroBlueToothMeshMgrOC *)shareInstance;


-(void)startScan;
-(void)restartScan;

-(void)stopScan;

-(void)connectMeshNode:(int)index;

//某个设备开关灯
- (void)onOffSetUnacknowledgedAndNum:(NSInteger)num withIson:(BOOL)isOn;
//设备设置 Relay
- (void)setRelayNum:(NSInteger)num withIson:(BOOL)ison;
//获取 Relay
- (void)getRelayNum:(NSInteger)num withIson:(BOOL)ison;
//获取 ProxyName
- (void)getProxyName;
//删除设备
- (void)removeDeviceNode:(NSInteger)num;
//本地删除设备
- (void)removeDeviceNodelocal:(NSInteger)num;
//添加组
- (void)setGroup:(NSString*)name;
//删除组
- (void)removeGroupAndName:(NSString *)name;
//修改组名称
- (void)modifyGroupAndName:(NSString *)name withNewName:(NSString *)newName;
//入网的设备
-(void)myDevice;
//设备添加组
- (void)addDeviceGroupWithNum:(NSInteger)num WithName:(NSString *)name;
//设备删除组
- (void)deleteDeviceGroupWithNum:(NSInteger)num WithName:(NSString *)name;
//控制组开关灯
- (void)setGroupOnOffSetUnacknowledgedOnOff:(BOOL)isOn withName:(NSString*)name;
//array中要么是只有一个0，要么是unprovison的节点所在的序列号
-(void)connectMeshNodeArray:(NSMutableArray *)array;

//设置ctl
- (void)setLightCTLSet:(NSInteger)num WithTemperature:(NSInteger)temperature Withlightness:(NSInteger)lightness;
//设置HSL
- (void)setLightHSLSet:(NSInteger)num WithSaturation:(NSInteger)saturation Withlightness:(NSInteger)lightness  Withhue:(NSInteger)hue;
//设置操作码
- (void)setNumber:(NSInteger)num WithSaturationNumber:(NSInteger)number;
-(void)provisionDeviceFinded:(CBPeripheral *)device;
-(void)unprovisionDeviceFinded:(CBPeripheral *)device;

@end

