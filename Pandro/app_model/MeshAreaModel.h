//
//  MeshAreaModel.h
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MeshPlaceModel;
@class MeshDeviceModel;

@interface MeshAreaModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *areaId;
@property(nonatomic, copy)NSString *iconName;

@property(nonatomic, strong)NSMutableArray *deviceArray;

@property(nonatomic, weak)MeshPlaceModel *placeModel;

@property(nonatomic)BOOL favorite;

-(id)initWithDict:(NSMutableDictionary *)model placeModel:(MeshPlaceModel *)placeModel;
-(NSMutableDictionary *)modelToDict;


-(BOOL)checkContainDevice:(MeshDeviceModel *)deviceModel;

@end


