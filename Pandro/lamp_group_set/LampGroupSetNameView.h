//
//  LampGroupSetNameView.h
//  Pandro
//
//  Created by chun on 2019/1/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^clickdSetNameSure)(NSString *name);

@interface LampGroupSetNameView : UIControl

@property(nonatomic, strong)UILabel *nameTipLabel;
@property(nonatomic, strong)UITextField *textField;

@property(nonatomic, copy)clickdSetNameSure clickedBlock;

-(id)initWithFrame:(CGRect)frame groupName:(NSString *)groupName;


@end

