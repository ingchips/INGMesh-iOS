//
//  LampDeviceRemoteControlView.h
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^clickdSetControlSure)(NSString *name);



@interface LampDeviceRemoteControlView : UIControl

@property(nonatomic, copy)clickdSetControlSure clickedBlock;

@end

