//
//  MeshPlaceModel.m
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"

@implementation MeshPlaceModel

-(id)initWithDict:(NSMutableDictionary *)model
{
    self = [super init];
    self.name = [model valueForKey:@"name"];
    self.password = [model valueForKey:@"password"];
    self.iconColor = [model valueForKey:@"iconColor"];
    self.iconName = [model valueForKey:@"iconName"];
    self.placeId = [model valueForKey:@"placeId"];
    self.favorite = [[model valueForKey:@"favorite"] boolValue];
    
    self.deviceArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dictItem in [model valueForKey:@"deviceArray"])
    {
        MeshDeviceModel *deviceModel = [[MeshDeviceModel alloc] initWithDict:dictItem];
        [self.deviceArray addObject:deviceModel];
        NSLog(@"device array dict init  %@ %d",deviceModel.name,self.areaArray.count);
    }
    
    self.areaArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dictItem in [model valueForKey:@"areaArray"])
    {
        MeshAreaModel *areaModel = [[MeshAreaModel alloc] initWithDict:dictItem placeModel:self];
        [self.areaArray addObject:areaModel];
    }
    
    
    return self;
}

-(NSMutableDictionary *)modelToDict
{
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
    
    [dictItem setValue:self.name forKey:@"name"];
    [dictItem setValue:self.password forKey:@"password"];
    [dictItem setValue:self.iconColor forKey:@"iconColor"];
    [dictItem setValue:self.iconName forKey:@"iconName"];
    [dictItem setValue:self.placeId forKey:@"placeId"];
    [dictItem setValue:@"0" forKey:@"favorite"];
    if (self.favorite)
    {
        [dictItem setValue:@"1" forKey:@"favorite"];
    }
    
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (MeshDeviceModel *deviceModel in self.deviceArray)
    {
        NSMutableDictionary *dict = [deviceModel modelToDict];
        [deviceArray addObject:dict];
    }
    [dictItem setValue:deviceArray forKey:@"deviceArray"];
    
    NSMutableArray *arArray = [[NSMutableArray alloc] init];
    for (MeshAreaModel *areaModel in self.areaArray)
    {
        NSMutableDictionary *dict = [areaModel modelToDict];
        [arArray addObject:dict];
    }
    [dictItem setValue:arArray forKey:@"areaArray"];
    

    return dictItem;
}
@end
