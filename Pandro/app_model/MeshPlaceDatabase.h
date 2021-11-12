//
//  MeshPlaceDatabase.h
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"

@interface MeshPlaceDatabase : NSObject

@property(nonatomic, strong)NSMutableArray *placeArray;

+(MeshPlaceDatabase *)shareInstance;

-(void)refreshDatabase;
-(void)savaDatabase;

/**
 add a place

 @param name name description
 @param favorite favorite description
 @return return fail reason
 */

-(BOOL)checkContainPlaceName:(NSString *)name;
-(NSString *)addPlace:(NSString *)name;

-(NSString *)addPlace:(NSString *)name password:(NSString *)password icon:(NSString *)icon color:(NSString *)color favorite:(BOOL)favorite;

-(void)deletePlaceWithPlace:(MeshPlaceModel *)placeModel;



-(NSString *)addAreaForPlace:(NSString *)placeId areaName:(NSString *)areaName;
-(NSString *)updateAreaForPlace:(NSString *)placeId areaId:(NSString *)areaId areaName:(NSString *)areaName;
-(BOOL)deleteAreaForPlace:(NSString *)placeId areaId:(NSString *)areaId;

-(NSString *)addDeviceForPlace:(NSString *)placeId deviceName:(NSString *)deviceName;

-(MeshPlaceModel *)placeModelFromPlaceId:(NSString *)placeId;

-(void)addAreaDeviceFromPlace:(NSString *)placeId areaId:(NSString *)areaId deviceId:(NSString *)deviceId;
-(void)deleteAreaDeviceFromPlace:(NSString *)placeId areaId:(NSString *)areaId deviceId:(NSString *)deviceId;
-(void)deleteAreaDeviceFromPlace:(NSString *)placeId deviceId:(NSString *)deviceId;


@end

