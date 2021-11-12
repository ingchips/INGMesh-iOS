//
//  MeshDeviceModel.h
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MeshAreaModel;

@interface MeshDeviceModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *deviceId;

@property(nonatomic, weak)MeshAreaModel *areaModel;

@property(nonatomic)BOOL switchOn;

@property(nonatomic,assign)NSInteger isGroupNum;


-(id)initWithDict:(NSMutableDictionary *)model;

-(NSMutableDictionary *)modelToDict;


@end

