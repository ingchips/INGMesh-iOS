//
//  MeshPlaceListCell.m
//  Pandro
//
//  Created by chun on 2018/12/21.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshPlaceListCell.h"
#import "PandroEngine.h"

@interface MeshPlaceListCell ()

@property(nonatomic, strong)MeshPlaceModel *placeModel;

@property(nonatomic, strong)UIView *separateView;
@property(nonatomic, strong)UIImageView *iconView;

@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *tipLabel;

@end

@implementation MeshPlaceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self addSubview:self.separateView];
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tipLabel];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float leftOffset = 15;
    
    self.separateView.frame = CGRectMake(15, self.frame.size.height - 0.5, self.frame.size.width - 30, 0.5);
    self.iconView.frame = CGRectMake(leftOffset, (self.frame.size.height - 35)/2, 35, 35);
    
    leftOffset = self.iconView.frame.size.width + self.iconView.frame.origin.x + 15;
    self.nameLabel.frame = CGRectMake(leftOffset, self.frame.size.height/2 - 20, self.frame.size.width - leftOffset - 10, 20);
    
    self.tipLabel.frame = CGRectMake(leftOffset, self.frame.size.height /2 , self.frame.size.width - leftOffset - 10, 20);
    
}

-(void)showContentFromModel:(MeshPlaceModel *)model
{
    self.placeModel = model;
    
    if (model.iconName)
    {
        NSArray *array = [model.iconColor componentsSeparatedByString:@","];
        if (array.count != 3)
        {
            self.iconView.image = [UIImage loadImageWithName:model.iconName];
        }
        else
        {
            UIColor *tmpColor = [UIColor colorWithRed:[(NSString *)[array objectAtIndex:0] floatValue] green:[(NSString *)[array objectAtIndex:1] floatValue] blue:[(NSString *)[array objectAtIndex:2] floatValue] alpha:1];
            
            self.iconView.tintColor = tmpColor;
            self.iconView.image = [[UIImage loadImageWithName:model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    self.nameLabel.text = model.name;
    self.tipLabel.text = model.name;
    
}

#pragma mark setter and getter
-(UIView *)separateView
{
    if (!_separateView)
    {
        _separateView = [[UIView alloc] initWithFrame:CGRectZero];
        _separateView.backgroundColor = [UIColor littleGrayPandroColor];
        
    }
    return _separateView;
}

-(UIImageView *)iconView
{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconView.layer setCornerRadius:5];
        [_iconView.layer setMasksToBounds:YES];
    }
    return _iconView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackPandroColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _nameLabel;
}

-(UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor grayPandroColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tipLabel;
}
@end
