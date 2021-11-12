//
//  LampDeviceSetHeaderView.h
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LampDeviceSetHeaderView : UIScrollView

@property(nonatomic, copy)NSString *placeId;
@property(nonatomic, copy)NSString *areaId;
@property(nonatomic, copy)NSString *deviceId;


-(void)initContentUI;

-(void)clickHeaderButton:(UIControl *)btn;

@end

NS_ASSUME_NONNULL_END
