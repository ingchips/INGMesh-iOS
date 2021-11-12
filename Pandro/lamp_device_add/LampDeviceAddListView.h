//
//  LampDeviceAddListView.h
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
// 搜索列表

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface LampDeviceAddListView : UIView

-(void)showBlueToothDeviceContent;

@end

@interface LampDeviceAddListCellModel : NSObject

@property(nonatomic) int deviceState;
@property(nonatomic, strong)NSString *deviceName;

@property(nonatomic, strong)CBPeripheral *peripheralDevice;


@end

NS_ASSUME_NONNULL_END
