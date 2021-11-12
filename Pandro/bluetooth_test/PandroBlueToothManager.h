//
//  PandroBlueToothManager.h
//  Pandro
//
//  Created by chun on 2018/12/17.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol PandroBlueToothManagerDelegate <NSObject>

-(void)discoverBlueDevice:(CBPeripheral *)peripheral;

-(void)connectedBlueDeviceArray:(NSMutableArray *)array;

@end


@interface PandroBlueToothManager : NSObject

@property(nonatomic, copy)NSString *deviceName;
@property(nonatomic, copy)NSString *serviceId;
@property(nonatomic, weak)id<PandroBlueToothManagerDelegate> delegate;

+(PandroBlueToothManager *)shareInstance;

-(void)scanBlueTooth;
-(void)stopScan;

-(void)connectDeviceArray:(NSMutableArray *)connectArray;

@end

