//
//  PandroBlueToothManager.m
//  Pandro
//
//  Created by chun on 2018/12/17.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "PandroBlueToothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PandroBlueToothManager ()

@property(nonatomic)BOOL scaning;
@property(nonatomic, strong)CBCentralManager *centerManager;
@property(nonatomic, strong)NSMutableDictionary *deviceDict;
@property(nonatomic, strong)NSMutableArray *deviceArray;
@property(nonatomic, strong)CBPeripheral *connectingPeripheral;
@property(nonatomic, strong)CBPeripheral *peripheral;
@property(nonatomic, strong)CBCharacteristic *characteristic;

@property(nonatomic, strong)CBCharacteristic *writeCharacter;
@property(nonatomic, strong)CBCharacteristic *readCharacter;

@property(nonatomic, strong)NSMutableArray *connectArray;
@property(nonatomic, strong)NSMutableArray *connectSucceedArray;

@property(nonatomic)int connectIndex;

@end



@implementation PandroBlueToothManager

+(PandroBlueToothManager *)shareInstance
{
    static PandroBlueToothManager *shareMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMgr = [[PandroBlueToothManager alloc] init];
    });
    
    return shareMgr;
}

-(id)init
{
    self = [super init];
    
    self.scaning = NO;
    self.deviceDict = [[NSMutableDictionary alloc] init];
    self.deviceArray = [[NSMutableArray alloc] init];
    
    self.deviceName = @"My Mambo";
    self.serviceId = @"FCC0";
    
    return self;
}

-(void)scanBlueTooth
{
    if (self.scaning)
    {
        return;
    }
    
    self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

-(void)stopScan
{
    [self.centerManager stopScan];
}


-(void)connectBlueTooth:(CBPeripheral *)peripheral
{
    self.connectingPeripheral = peripheral;
    [self.centerManager connectPeripheral:peripheral options:nil];
    
    [self stopScan];
    
}

-(void)connectDeviceArray:(NSMutableArray *)connectArray
{
    self.connectIndex = 0;
    
    self.connectArray = connectArray;
    self.connectSucceedArray = [[NSMutableArray alloc] init];
    
    [self connectDeviceArrayNext];
    
}

-(void)connectDeviceArrayNext
{
    if (self.connectIndex < self.connectArray.count)
    {
        [self.centerManager cancelPeripheralConnection:self.connectingPeripheral];
        
        CBPeripheral *peripheralDevice = [self.connectArray objectAtIndex:self.connectIndex];
        self.connectingPeripheral = peripheralDevice;
        [self.centerManager connectPeripheral:peripheralDevice options:nil];
        
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(connectedBlueDeviceArray:)])
        {
            [self.delegate connectedBlueDeviceArray:self.connectSucceedArray];
        }
    }
}


-(void)connectBlueToothService:(NSString *)serverid
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self.peripheral discoverServices:nil];
    
}

#pragma mark CBCenteralManager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            [self.centerManager scanForPeripheralsWithServices:nil options:nil];
            
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"bluetooth find device :%@", peripheral.name);
    
    if ([peripheral.name containsString:@"INGCHIPS"])
    {
        [self.centerManager stopScan];
        NSLog(@"%@", advertisementData);
        self.peripheral = peripheral;
        //[self.centerManager connectPeripheral:peripheral options:nil];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@YES forKey:CBConnectPeripheralOptionNotifyOnConnectionKey];
        [dict setValue:@YES forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
        [self.centerManager connectPeripheral:peripheral options:dict];
    }
    
    /*
    if (![self.deviceArray containsObject:peripheral])
    {
        [self.deviceArray addObject:peripheral];
        //[self.deviceDict setValue:peripheral forKey:peripheral.name];
        
        if ([self.delegate respondsToSelector:@selector(discoverBlueDevice:)])
        {
            [self.delegate discoverBlueDevice:peripheral];
        }
    }
    */
    
    /*
    
    if (![self.deviceDict objectForKey:peripheral.name])
    {
        if (peripheral && peripheral.name)
        {
            [self.deviceDict setObject:peripheral forKey:peripheral.name];
            if ([peripheral.name containsString:self.deviceName])
            {
                [self connectBlueTooth:peripheral];
            }
            
        }
    }
    */
}

#pragma mark connect

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"bluetooth didConnectPeripheral");
    
    [self stopScan];
    peripheral.delegate = self;
    self.peripheral = peripheral;
    
    [self.connectSucceedArray addObject:peripheral];
    self.connectIndex++;
    [self connectDeviceArrayNext];
    //[self connectBlueToothService:nil];
    
    [self.peripheral discoverServices:nil];
    printf("devie connected\n");
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    NSLog(@"bluetooth didFailToConnectPeripheral");
    
    self.connectIndex++;
    [self connectDeviceArrayNext];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    NSLog(@"bluetooth didDisconnectPeripheral");
    
}

#pragma mark service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    NSLog(@"bluetooth discover service");
    NSLog(@"peripheral service is %@", peripheral.services);
    {
        CBService *findService = peripheral.services.firstObject;
        
        
        if (findService)
        {
            [peripheral discoverCharacteristics:nil forService:findService];
        }
        
        return;
    }
    
    CBService *findService = nil;
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:self.serviceId]])
        {
            findService = service;
            break;
        }
    }
    
    findService = [peripheral.services lastObject];
    
    if (findService)
    {
        [peripheral discoverCharacteristics:nil forService:findService];
    }
}

#pragma mark discover charactor
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    NSLog(@"bluetooth discover character");
    NSLog(@"peripheral character is %@", service.characteristics);
    
    for (CBCharacteristic *charcteristic in service.characteristics)
    {
        //[charcteristic.UUID isEqual:[CBUUID UUIDWithString:@""]];
        //self.characteristic = charcteristic;
        
        //[peripheral setNotifyValue:YES forCharacteristic:charcteristic];
        
        //NSData *data = [@"string" dataUsingEncoding:NSUTF8StringEncoding];
        //[self.peripheral writeValue:data forCharacteristic:charcteristic type:CBCharacteristicWriteWithResponse];
        
        if ([charcteristic.UUID.UUIDString isEqualToString:@"2ADB"])
        {
            self.writeCharacter = charcteristic;
        }
        else if ([charcteristic.UUID.UUIDString isEqualToString:@"2ADC"])
        {
            
            
            self.readCharacter = charcteristic;
            [peripheral setNotifyValue:YES forCharacteristic:charcteristic];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
        //
        NSMutableData *data = [[NSMutableData alloc] init];
        unsigned char szMem[3];
        szMem[0] = 0x03;
        szMem[1] = 0x00;
        szMem[2] = 0x05;
        [data appendBytes:szMem length:3];
        [weakSelf.peripheral writeValue:data forCharacteristic:weakSelf.writeCharacter type:CBCharacteristicWriteWithoutResponse];
        
        //[weakSelf.peripheral readValueForCharacteristic:weakSelf.readCharacter];
    }];
}
- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral
{
    NSLog(@"peripheralIsReadyToSendWriteWithoutResponse");
}
 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    NSLog(@"写入成功");
}

#pragma mark read data
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    NSLog(@"character notify is %d", characteristic.isNotifying);
    
    if (characteristic.isNotifying)
    {
        [peripheral readValueForCharacteristic:characteristic];
    }
    else
    {
        //[self.centerManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    NSLog(@"read value is %@", characteristic.value);
    
    NSString *str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"read value is %@", str);
    
    
    /*
    NSData *jsonData = [characteristic.value dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"value is %@", dataDic);
    // 将字典传出去就可以使用了
    */
}

@end
