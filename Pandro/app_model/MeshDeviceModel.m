//
//  MeshDeviceModel.m
//  Pandro
//
//  Created by chun on 2018/12/18.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshDeviceModel.h"

@implementation MeshDeviceModel

-(id)initWithDict:(NSMutableDictionary *)model
{
    self = [super init];
    self.name = [model valueForKey:@"name"];
    self.deviceId = [model valueForKey:@"deviceId"];
    
    return self;
}

-(NSMutableDictionary *)modelToDict
{
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
    
    [dictItem setValue:self.name forKey:@"name"];
    [dictItem setValue:self.deviceId forKey:@"deviceId"];    
    
    return dictItem;
}
@end
