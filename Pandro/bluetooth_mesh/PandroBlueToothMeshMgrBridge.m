//
//  PandroBlueToothMeshMgrBridge.m
//  Pandro
//
//  Created by chun on 2019/4/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroBlueToothMeshMgrBridge.h"

@implementation PandroBlueToothMeshMgrBridge

+(PandroBlueToothMeshMgrBridge *)shareInstance
{
    static PandroBlueToothMeshMgrBridge *kMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kMgr = [[PandroBlueToothMeshMgrBridge alloc] init];
        kMgr.provisionNodes = [[NSMutableArray alloc] init];
        kMgr.unprovisionNodes = [[NSMutableArray alloc] init];
    });
    
    return kMgr;
}

-(void)provisionDeviceFinded:(CBPeripheral *)device
{
    [self.provisionNodes addObject:device];
    
    if ([self.delegate respondsToSelector:@selector(blueToothDevicesHasFinded)])
    {
        [self.delegate blueToothDevicesHasFinded];
    }
    
}

-(void)unprovisionDeviceFinded:(CBPeripheral *)device
{
    [self.unprovisionNodes addObject:device];

    if ([self.delegate respondsToSelector:@selector(blueToothDevicesHasFinded)])
    {
        [self.delegate blueToothDevicesHasFinded];
    }
}
-(void)myDeviceFinded:(NSArray *)deviceArr{
    self.myDeviceArr = deviceArr;
}
-(void)blueToothDevicesMeshProxySucceed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueToothDevicesMeshProxySucceed)])
    {
        [self.delegate blueToothDevicesMeshProxySucceed];
    }
    
}

-(void)blueToothDevicesMeshProxyFailed
{
    if ([self.delegate respondsToSelector:@selector(blueToothDevicesMeshProxyFailed)])
    {
        [self.delegate blueToothDevicesMeshProxyFailed];
    }
}
@end
