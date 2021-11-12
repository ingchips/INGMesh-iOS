//
//  LampDeviceAddSearchManager.m
//  Pandro
//
//  Created by chun on 2019/3/13.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddSearchManager.h"
#import "PandroBlueToothManager.h"


@implementation LampDeviceAddSearchManager

+(LampDeviceAddSearchManager *)shareInstance
{
    static LampDeviceAddSearchManager *gInsMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInsMgr = [[LampDeviceAddSearchManager alloc] init];
    });
    
    return gInsMgr;
}

+(void)startScan
{
    LampDeviceAddSearchManager *shareMgr = [LampDeviceAddSearchManager shareInstance];
    
    shareMgr.searchArray = [[NSMutableArray alloc] init];

    PandroBlueToothManager *blueToothMgr = [PandroBlueToothManager shareInstance];
    blueToothMgr.delegate = self;
    [blueToothMgr scanBlueTooth];
}

+(void)stopScan
{
    [[PandroBlueToothManager shareInstance] stopScan];
    
}

-(id)init
{
    self = [super init];
    
    return self;
}

#pragma mark PandroBlueTooth delgeate
-(void)discoverBlueDevice:(CBPeripheral *)peripheral
{
    [self.searchArray addObject:peripheral];
}

@end
