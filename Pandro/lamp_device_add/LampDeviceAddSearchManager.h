//
//  LampDeviceAddSearchManager.h
//  Pandro
//
//  Created by chun on 2019/3/13.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LampDeviceAddSearchObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface LampDeviceAddSearchManager : NSObject

@property(nonatomic, strong)NSMutableArray *searchArray;


+(LampDeviceAddSearchManager *)shareInstance;

+(void)startScan;
+(void)stopScan;



@end

NS_ASSUME_NONNULL_END
