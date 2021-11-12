//
//  LampDeviceAddViewController.h
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PandroEngine.h"


@interface LampDeviceAddViewController : PandroSuperViewController

-(void)clickTrySearchAgain:(UIButton *)btn;
-(void)clickTryConnectAgain:(UIButton *)btn;

-(void)clickConnectDevice:(NSMutableArray *)deviceArray;
-(void)clickDirectGoto:(UIButton *)btn;

@end

