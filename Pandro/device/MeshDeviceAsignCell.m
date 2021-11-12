//
//  MeshDeviceAsignCell.m
//  Pandro
//
//  Created by chun on 2019/1/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "MeshDeviceAsignCell.h"
#import "PandroEngine.h"

@interface MeshDeviceAsignCell ()

@property(nonatomic, strong)MeshDeviceModel *deviceModel;

@property(nonatomic, strong)UIView *separateView;
@property(nonatomic, strong)UIImageView *iconView;

@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *tipLabel;

@property(nonatomic, strong)UIButton *settingBtn;

@end

@implementation MeshDeviceAsignCell

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
    [self addSubview:self.settingBtn];
    
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
    
    self.settingBtn.frame = CGRectMake(self.frame.size.width - 50, (self.frame.size.height - 40)/2, 40, 40);
}

-(void)showContentFromModel:(MeshDeviceModel *)model
{
    self.deviceModel = model;
    
    if ([self.areaModel  checkContainDevice:model])
    {
        [self.settingBtn setHidden:NO];
    }
    else
    {
        [self.settingBtn setHidden:YES];
    }
    
    self.nameLabel.text = model.name;
    self.tipLabel.text = model.name;
    
}

#pragma mark click
-(void)clickSetting:(id)sender
{
    /*
     PandroSuperViewController *pageVC = [self selfViewController];
     
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
     [dict setValue:self.areaModel.placeModel.placeId forKey:@"placeId"];
     [dict setValue:self.areaModel.areaId forKey:@"areaId"];
     [dict setValue:self.areaModel.name forKey:@"name"];
     
     [pageVC gotoPage:PAGE_AREA_ADD_VIEWCONTROLLER params:dict command:@"update"];
     */
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
        _iconView.image = [UIImage loadImageWithName:@"ic_light"];
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
-(UIButton *)settingBtn
{
    if (!_settingBtn)
    {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage loadImageWithName:@"ic_selected"] forState:UIControlStateNormal];
    }
    return _settingBtn;
}
@end
