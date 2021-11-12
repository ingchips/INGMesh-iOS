//
//  MeshAreaListCell.h
//  Pandro
//
//  Created by chun on 2018/12/24.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MeshAreaModel.h"

@interface MeshAreaListCell : UITableViewCell

-(void)showContentFromModel:(MeshAreaModel *)model;

@end


