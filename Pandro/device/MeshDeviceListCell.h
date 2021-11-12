//
//  MeshDeviceListCell.h
//  Pandro
//
//  Created by chun on 2018/12/24.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDeviceModel.h"

@interface MeshDeviceListCell : UITableViewCell

-(void)showContentFromModel:(MeshDeviceModel *)model;

@end

