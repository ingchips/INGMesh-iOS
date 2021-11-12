//
//  MeshPlaceModel.h
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeshPlaceModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *placeId;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *iconName;
@property(nonatomic, copy)NSString *iconColor;

@property(nonatomic, strong)NSMutableArray *areaArray;
@property(nonatomic, strong)NSMutableArray *deviceArray;

@property(nonatomic)BOOL favorite;

-(id)initWithDict:(NSMutableDictionary *)model;
-(NSMutableDictionary *)modelToDict;

@end


