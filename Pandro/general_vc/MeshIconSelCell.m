//
//  MeshIconSelCell.m
//  Pandro
//
//  Created by chun on 2018/12/25.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshIconSelCell.h"
#import "PandroEngine.h"

@interface MeshIconSelCell ()

@property(nonatomic, strong)NSMutableArray *contentArray;
@property(nonatomic, strong)NSMutableArray *controlArray;


@end

@implementation MeshIconSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    float offset = self.frame.size.width / 4.0;
    for (int i=0;i<4;i++)
    {
        CGRect rect = CGRectMake(i * offset, 0, offset, offset);
        UIButton *btn = [self.controlArray objectAtIndex:i];
        btn.frame = rect;
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    for (int i=0; i<4; i++)
    {
        [self addSubview:[self.controlArray objectAtIndex:i]];
    }
    
    return self;
}

-(void)showContentFromArray:(NSMutableArray *)iconArray
{
    self.contentArray = iconArray;
    for (int i=0;i<4; i++)
    {
        [[self.controlArray objectAtIndex:i] setHidden:YES];
    }
    for (int i=0; i<iconArray.count; i++)
    {
        UIButton *btn = [self.controlArray objectAtIndex:i];
        [btn setHidden:NO];
        [btn setImage:[UIImage loadImageWithName:[iconArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
}
#pragma mark click
-(void)clickControl:(UIButton *)btn
{
    int index = 0;
    for (int i=0; i<4; i++)
    {
        UIButton *btnTmp = [self.controlArray objectAtIndex:i];
        if ([btnTmp isEqual:btn])
        {
            index = i;
            break;
        }
    }
    
    PandroSuperViewController *vc = [self selfViewController];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[self.contentArray objectAtIndex:index] forKey:@"icon"];
    [vc popPage:dict command:@"icon"];
}

#pragma mark getter and setter
-(NSMutableArray *)controlArray
{
    if (!_controlArray)
    {
        _controlArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_controlArray addObject:btn];
            [btn addTarget:self action:@selector(clickControl:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _controlArray;
}


@end
