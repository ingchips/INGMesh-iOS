//
//  PandroBlueToothMeshMgrBridge.h
//  Pandro
//
//  Created by chun on 2019/4/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBlueTooth/CoreBlueTooth.h>

@protocol PandroBlueToothMeshMgrBridgeDelegate <NSObject>

-(void)blueToothDevicesHasFinded;
-(void)blueToothDevicesMeshProxySucceed;
-(void)blueToothDevicesMeshProxyFailed;

@end


@interface PandroBlueToothMeshMgrBridge : NSObject

@property(nonatomic, strong)NSMutableArray *provisionNodes;
@property(nonatomic, strong)NSMutableArray *unprovisionNodes;
@property(nonatomic, strong)NSArray *myDeviceArr;


@property(nonatomic, weak)id<PandroBlueToothMeshMgrBridgeDelegate> delegate;


+(PandroBlueToothMeshMgrBridge *)shareInstance;

-(void)provisionDeviceFinded:(CBPeripheral *)device;
-(void)unprovisionDeviceFinded:(CBPeripheral *)device;
-(void)myDeviceFinded:(NSArray *)deviceArr;

-(void)blueToothDevicesMeshProxySucceed;
-(void)blueToothDevicesMeshProxyFailed;

@end

