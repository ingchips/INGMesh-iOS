//
//  PandroButton.h
//  Pandro
//
//  Created by chun on 2019/1/21.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PandroButton;

@protocol PandroButtonProtocol <NSObject>

-(void)clickedPandroButton:(PandroButton *)button;

@end

@interface PandroButton : UIControl

@property(nonatomic, strong)NSMutableDictionary *dictItem;
@property(nonatomic, copy)NSString *btnIdentifier;

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *titleLabe;


-(id)initWithTitle:(NSString *)title image:(NSString *)image frame:(CGRect)frame;

@property(nonatomic, weak)id<PandroButtonProtocol> delegate;


@end

