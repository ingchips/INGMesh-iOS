//
//  LampMeshGroupCell.h
//  Pandro
//
//  Created by chun on 2019/3/1.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LampMeshViewGroupModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol LampMeshGroupCellDelegate <NSObject>
 - (void)selectedGroupItemButton:(NSIndexPath*)indexPath;
@end

@interface LampMeshGroupCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<LampMeshGroupCellDelegate> lampMeshGroupDeviceCellDelegate;
@property(nonatomic, copy)NSString *placeId;
@property(nonatomic,strong)NSString *nameStr;


-(void)showContentFromModule:(LampMeshViewGroupModel *)module;

@end

NS_ASSUME_NONNULL_END
