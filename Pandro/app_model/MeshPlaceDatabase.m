//
//  MeshPlaceDatabase.m
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshPlaceDatabase.h"
#import "PandroBlueToothMeshMgrOC.h"
@interface MeshPlaceDatabase ()

@property(nonatomic, copy)NSString *databaseFileName;
@property(nonatomic, strong)NSRecursiveLock *lock;

@end

@implementation MeshPlaceDatabase

+(MeshPlaceDatabase *)shareInstance
{
    static MeshPlaceDatabase *insDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        insDatabase = [[MeshPlaceDatabase alloc] init];
        [insDatabase refreshDatabase];
    });
    
    return insDatabase;
}

-(id)init
{
    self = [super init];
    
    self.lock = [[NSRecursiveLock alloc] init];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.databaseFileName = [NSString stringWithFormat:@"%@/%@", [array firstObject],  @"deviceDatabase"];
    
    
    return self;
}

-(void)refreshDatabase
{
    [self.lock lock];
    
    self.placeArray = [[NSMutableArray alloc] init];
   
    NSData *contentData = [NSData dataWithContentsOfFile:self.databaseFileName];
    if (!contentData)
    {
        [self.lock unlock];
        
        [self addPlace:@"默认家庭" password:nil icon:nil color:nil favorite:YES];
        return;
    }
    
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSMutableDictionary *dictItem in array)
    {
        MeshPlaceModel *placeModel = [[MeshPlaceModel alloc] initWithDict:dictItem];
        [self.placeArray addObject:placeModel];
    }
    
    [self.lock unlock];
}

-(void)savaDatabase
{
    [self.lock lock];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (MeshPlaceModel *placeModel in self.placeArray)
    {
        NSMutableDictionary *dictItem = [placeModel modelToDict];
        [dataArray addObject:dictItem];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:self.databaseFileName atomically:YES];
    
    [self.lock unlock];
}
#pragma mark place
-(BOOL)checkContainPlaceName:(NSString *)name
{
    BOOL exist = NO;
    
    for (MeshPlaceModel *placeModelTmp in self.placeArray)
    {
        if ([placeModelTmp.name isEqualToString:name])
        {
            exist = YES;
            break;
        }
    }
    
    
    return exist;
}
-(MeshPlaceModel *)placeModelFromPlaceId:(NSString *)placeId
{
    MeshPlaceModel *placeModel = nil;
    for (MeshPlaceModel *placeModelTmp in self.placeArray)
    {
        if ([placeModelTmp.placeId isEqualToString:placeId])
        {
            placeModel = placeModelTmp;
            break;
        }
    }
    
    return placeModel;
}

-(void)deletePlaceWithPlace:(MeshPlaceModel *)placeModel
{
    [self.placeArray removeObject:placeModel];
    [self savaDatabase];
}

-(NSString *)addPlace:(NSString *)name
{
    return [self addPlace:name password:nil icon:nil color:nil favorite:NO];
}

-(NSString *)addPlace:(NSString *)name  password:(NSString *)password icon:(NSString *)icon color:(NSString *)color favorite:(BOOL)favorite
{
    for (MeshPlaceModel *placeModel in self.placeArray)
    {
        if ([placeModel.name isEqualToString:name])
        {
            return @"name has existed";
        }
    }
    if (favorite)
    {
        for (MeshPlaceModel *placeModel in self.placeArray)
        {
            placeModel.favorite = NO;
        }
    }
    MeshPlaceModel *placeModel = [[MeshPlaceModel alloc] init];
    placeModel.name = name;
    if (password)
    {
        placeModel.password = password;
    }
    if (icon)
    {
        placeModel.iconName = icon;
    }
    if (color)
    {
        placeModel.iconColor = color;
    }
    
    placeModel.favorite = favorite;
    placeModel.placeId = [NSString stringWithFormat:@"%lld", (long long )(1000 * [[NSDate date] timeIntervalSince1970])];
    placeModel.areaArray = [[NSMutableArray alloc] init];
    placeModel.deviceArray = [[NSMutableArray alloc] init];
    
    //[self.placeArray insertObject:placeModel atIndex:0];
    [self.placeArray addObject:placeModel];
    [self savaDatabase];
    
    return nil;
}

#pragma mark area
-(NSString *)addAreaForPlace:(NSString *)placeId areaName:(NSString *)areaName
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return @"not find place";
    }
    
    
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
        if ([areaModel.name isEqualToString:areaName])
        {
            return @"name has existed";
        }
    }
    [[PandroBlueToothMeshMgrOC shareInstance] setGroup:areaName];
    
    MeshAreaModel *areaModel = [[MeshAreaModel alloc] init];
    areaModel.name = areaName;
    areaModel.iconName = @"group_set_icon_lamp_sel";
    areaModel.areaId = [NSString stringWithFormat:@"%lld", (long long )(1000 * [[NSDate date] timeIntervalSince1970])];
    areaModel.deviceArray = [[NSMutableArray alloc] init];
    [placeModel.areaArray insertObject:areaModel atIndex:0];
    [self savaDatabase];
    
    return nil;
}

-(NSString *)updateAreaForPlace:(NSString *)placeId areaId:(NSString *)areaId areaName:(NSString *)areaName
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return @"not find place";
    }
    
    MeshAreaModel *areaModelModify = nil;
    
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
        if ([areaModel.areaId isEqualToString:areaId])
        {
            areaModelModify = areaModel;
        }
        if ([areaModel.name isEqualToString:areaName] && ![areaModel.areaId isEqualToString:areaId])
        {
            return @"name has existed";
        }
    }
    
    areaModelModify.name = areaName;
    
    [self savaDatabase];
    
    return nil;
}

-(BOOL)deleteAreaForPlace:(NSString *)placeId areaId:(NSString *)areaId
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return NO;
    }
    
    MeshAreaModel *areaModelModify = nil;
    
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
        if ([areaModel.areaId isEqualToString:areaId])
        {
            areaModelModify = areaModel;
            break;
        }
    }
    
    [placeModel.areaArray removeObject:areaModelModify];
    
    [self savaDatabase];
    
    return YES;
}

#pragma mark device
-(NSString *)addDeviceForPlace:(NSString *)placeId deviceName:(NSString *)deviceName
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return @"not find place";
    }
    
    
    for (MeshDeviceModel *deviceModel in placeModel.deviceArray)
    {
        if ([deviceModel.name isEqualToString:deviceName])
        {
            return @"name has existed";
        }
    }
    
    MeshDeviceModel *deviceModel = [[MeshDeviceModel alloc] init];
    deviceModel.name = deviceName;
    deviceModel.deviceId = [NSString stringWithFormat:@"%lld", (long long )(1000 * [[NSDate date] timeIntervalSince1970])];
    
    [placeModel.deviceArray insertObject:deviceModel atIndex:0];
    [self savaDatabase];
    
    return nil;
}

-(void)addAreaDeviceFromPlace:(NSString *)placeId areaId:(NSString *)areaId deviceId:(NSString *)deviceId
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return;
    }
    
    MeshAreaModel *areaModelModify = nil;
    
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
        if ([areaModel.areaId isEqualToString:areaId])
        {
            areaModelModify = areaModel;
            break;
        }
    }
    
    MeshDeviceModel *deviceModelModify = nil;
    for (MeshDeviceModel *deviceModel in placeModel.deviceArray)
    {
        if ([deviceModel.deviceId isEqualToString:deviceId])
        {
            deviceModelModify = deviceModel;
            break;
        }
    }
    
    [areaModelModify.deviceArray addObject:deviceModelModify];
    NSLog(@"device array add device %@ %d",deviceModelModify.name,areaModelModify.deviceArray.count);
    [self savaDatabase];
}
-(void)deleteAreaDeviceFromPlace:(NSString *)placeId areaId:(NSString *)areaId deviceId:(NSString *)deviceId
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return;
    }
    
    MeshAreaModel *areaModelModify = nil;
    
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
        if ([areaModel.areaId isEqualToString:areaId])
        {
            areaModelModify = areaModel;
            break;
        }
    }
    
    MeshDeviceModel *deviceModelModify = nil;
    for (MeshDeviceModel *deviceModel in placeModel.deviceArray)
    {
        if ([deviceModel.deviceId isEqualToString:deviceId])
        {
            deviceModelModify = deviceModel;
            break;
        }
    }
    NSInteger remove = 0;
    for (MeshDeviceModel *deviceModel in areaModelModify.deviceArray) {
        if ([deviceModel.deviceId isEqualToString:deviceModelModify.deviceId])
        {
            [areaModelModify.deviceArray removeObjectAtIndex:remove];
            break;
        }
            remove++;
    }
//    [areaModelModify.deviceArray removeObject:deviceModelModify];
    
    [self savaDatabase];
}
-(void)deleteAreaDeviceFromPlace:(NSString *)placeId deviceId:(NSString *)deviceId
{
    MeshPlaceModel *placeModel = [self placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return;
    }
    MeshAreaModel *areaModelModify = nil;
    for (MeshAreaModel *areaModel in placeModel.areaArray)
    {
            areaModelModify = areaModel;
            MeshDeviceModel *deviceModelModify = nil;
           for (MeshDeviceModel *deviceModel in placeModel.deviceArray)
           {
               if ([deviceModel.deviceId isEqualToString:deviceId])
               {
                   deviceModelModify = deviceModel;
                   break;
               }
           }
            NSInteger remove = 0;
           for (MeshDeviceModel *deviceModel in areaModelModify.deviceArray) {
               if ([deviceModel.deviceId isEqualToString:deviceModelModify.deviceId])
               {
                   [areaModelModify.deviceArray removeObjectAtIndex:remove];
                   break;
               }
                   remove++;
           }
    }
    [self savaDatabase];
}
@end
