//
//  MeshAreaModel.m
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"
#import "MeshPlaceModel.h"

@implementation MeshAreaModel

-(id)initWithDict:(NSMutableDictionary *)model placeModel:(MeshPlaceModel *)placeModel
{
    self = [super init];
    self.name = [model valueForKey:@"name"];
    self.areaId = [model valueForKey:@"areaId"];
    self.favorite = [[model valueForKey:@"favorite"] boolValue];
    self.iconName = [model valueForKey:@"iconName"];
    self.placeModel = placeModel;
    self.deviceArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dictItem in [model valueForKey:@"deviceArray"])
    {
        MeshDeviceModel *deviceModel = [self deviceModelWithDeviceId:[dictItem valueForKey:@"deviceId"]];
        if (deviceModel)
        {
            [self.deviceArray addObject:deviceModel];
        }
        
    }
    
    return self;
}

-(MeshDeviceModel *)deviceModelWithDeviceId:(NSString *)deviceId
{
    for (MeshDeviceModel *deviceModelTmp in self.placeModel.deviceArray)
    {
        if ([deviceModelTmp.deviceId isEqualToString:deviceId])
        {
            return deviceModelTmp;
        }
    }
    return nil;
}

-(NSMutableDictionary *)modelToDict
{
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
    
    [dictItem setValue:self.name forKey:@"name"];
    [dictItem setValue:self.areaId forKey:@"areaId"];
    [dictItem setValue:self.iconName forKey:@"iconName"];
    [dictItem setValue:@"0" forKey:@"favorite"];
    if (self.favorite)
    {
        [dictItem setValue:@"1" forKey:@"favorite"];
    }
    NSMutableArray *devArray = [[NSMutableArray alloc] init];
    for (MeshDeviceModel *deviceModel in self.deviceArray)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:deviceModel.deviceId forKey:@"deviceId"];
        [devArray addObject:dict];
    }
    [dictItem setValue:devArray forKey:@"deviceArray"];
    
    return dictItem;
}
-(BOOL)checkContainDevice:(MeshDeviceModel *)deviceModel
{
    if ([self.deviceArray containsObject:deviceModel])
    {
        return YES;
    }
    return NO;
}
@end
