//
//  PandroSuperViewController.h
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PandroNavBarView.h"
#import "PandroPageNameConfig.h"
#import "NSObject+Actor.h"



@interface PandroSuperViewController : UIViewController

@property(nonatomic, copy)NSString *pageCommand;
@property(nonatomic, strong)NSMutableDictionary *pageParams;

@property(nonatomic, strong)PandroNavBarView *navBar;


-(void)showNavBar;
-(void)showNavBarLeftBackButton;
-(void)showNavBarTitle:(NSString *)title;

//route
-(void)gotoPage:(NSString *)pageName params:(NSMutableDictionary *)params command:(NSString *)command;
-(void)popPage:(NSMutableDictionary *)params command:(NSString *)command;
-(void)popCountPage:(int)count params:(NSMutableDictionary *)params command:(NSString *)command;
-(void)popToPage:(NSString *)pageName params:(NSMutableDictionary *)params command:(NSString *)command;


@end

