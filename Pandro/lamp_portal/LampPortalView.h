//
//  LampPortalView.h
//  Pandro
//
//  Created by chun on 2019/1/18.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LampPortalModel.h"

@class LampPortalHeaderView;
@class LampPortalCellView;



@protocol LampPortalHeaderViewProtocol <NSObject>

-(void)clickedAddGroup:(LampPortalHeaderView *)headerView;
-(void)clickedShowGroup:(LampPortalHeaderView *)headerView;

@end

@protocol LampPortalCellViewProtocol <NSObject>

-(void)clickedCellControl:(LampPortalCellView *)cell model:(LampPortalModel *)model;
-(void)clickedCellManage:(LampPortalCellView *)cell model:(LampPortalModel *)model;
-(void)clickedCellDelete:(LampPortalCellView *)cell model:(LampPortalModel *)model;

@end


@interface LampPortalView : UIView

@end

@interface LampPortalHeaderView : UIView
@property(nonatomic, strong)UILabel *addTitleLabel;

@property(nonatomic, weak)id<LampPortalHeaderViewProtocol> delegate;

-(void)showAllGroupInTableview:(BOOL)show;
@end

@interface LampPortalCellView : UITableViewCell

@property(nonatomic, weak)id<LampPortalCellViewProtocol> delegate;

-(void)showContentFromModel:(LampPortalModel *)model;

@end
