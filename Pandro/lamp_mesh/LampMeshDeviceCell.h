//
//  LampMeshDeviceCell.h
//  Pandro
//
//  Created by chun on 2019/3/1.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeshDeviceModel.h"
#import "MeshPlaceModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol LampMeshDeviceCellDelegate <NSObject>
 - (void)selectedItemButton:(NSIndexPath*)indexPath;
@end

@interface LampMeshDeviceCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic, strong)MeshPlaceModel *placeModel;
@property(nonatomic,weak)id<LampMeshDeviceCellDelegate> lampMeshDeviceCellDelegate;
-(void)showContentFromModule:(MeshDeviceModel *)module;

@end

NS_ASSUME_NONNULL_END
