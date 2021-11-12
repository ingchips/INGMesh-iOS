//
//  LampMeshViewGroupModel.h
//  Pandro
//
//  Created by chun on 2019/3/4.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LampMeshViewGroupModel : NSObject

@property(nonatomic)BOOL allDeviceGroup;
@property(nonatomic)BOOL showExpand;
@property(nonatomic)BOOL isOn;



@property(nonatomic, strong)MeshAreaModel *areaModel;
@property(nonatomic, strong)NSMutableArray *deviceArray;

@end

NS_ASSUME_NONNULL_END
