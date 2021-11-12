//
//  MeshDeviceAsignCell.h
//  Pandro
//
//  Created by chun on 2019/1/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDeviceModel.h"
#import "MeshAreaModel.h"

@interface MeshDeviceAsignCell : UITableViewCell
@property(nonatomic, weak)MeshAreaModel *areaModel;

-(void)showContentFromModel:(MeshDeviceModel *)model;

@end

