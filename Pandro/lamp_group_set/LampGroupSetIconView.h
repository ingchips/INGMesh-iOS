//
//  LampGroupSetIconView.h
//  Pandro
//
//  Created by chun on 2019/1/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^clickdSetIconSure)(NSString *name);

@interface LampGroupSetIconView : UIControl

@property(nonatomic, copy)clickdSetIconSure clickedBlock;

-(id)initWithFrame:(CGRect)frame groupIcon:(NSString *)groupIcon;


@end

