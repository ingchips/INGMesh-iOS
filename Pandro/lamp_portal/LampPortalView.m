//
//  LampPortalView.m
//  Pandro
//
//  Created by chun on 2019/1/18.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalView.h"
#import "PandroEngine.h"

@implementation LampPortalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface LampPortalHeaderView ()

@property(nonatomic, strong)UIButton *addBtn;
@property(nonatomic, strong)UIButton *showBtn;
@property(nonatomic, strong)UILabel *textLabel;

@end

@implementation LampPortalHeaderView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self addSubview:self.addTitleLabel];
    [self addSubview:self.addBtn];
    [self addSubview:self.showBtn];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float btnWidth = self.frame.size.height;
    
    self.addTitleLabel.frame = CGRectMake(15, 0, self.frame.size.width/2, btnWidth);
    
    self.showBtn.frame = CGRectMake(self.frame.size.width - btnWidth, 0, btnWidth, btnWidth);
    
    self.addBtn.frame = CGRectMake(self.frame.size.width - 2 * btnWidth, 0, btnWidth, btnWidth);
    
}

#pragma mark click
-(void)clickAddBtn
{
    if ([self.delegate respondsToSelector:@selector(clickedAddGroup:)])
    {
        [self.delegate clickedAddGroup:self];
    }
}

-(void)clickShowBtn
{
    //show group
    if ([self.delegate respondsToSelector:@selector(clickedShowGroup:)])
    {
        [self.delegate clickedShowGroup:self];
    }
    
}

-(void)showAllGroupInTableview:(BOOL)showContent
{
    if (showContent)
    {
        [self.showBtn setImage:[UIImage loadImageWithName:@"group_icon_open_24x24_"] forState:UIControlStateNormal];
    }
    else
    {
        [self.showBtn setImage:[UIImage loadImageWithName:@"group_icon_up_24x24_"] forState:UIControlStateNormal];
    }
}
#pragma mark getter and setter
-(UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage loadImageWithName:@"group_icon_addGroup_24x24_"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UIButton *)showBtn
{
    if (!_showBtn)
    {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setImage:[UIImage loadImageWithName:@"group_icon_open_24x24_"] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(clickShowBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _showBtn;
}

-(UILabel *)addTitleLabel
{
    if (!_addTitleLabel)
    {
        _addTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addTitleLabel.backgroundColor = [UIColor clearColor];
        _addTitleLabel.font = [UIFont systemFontOfSize:16];
        _addTitleLabel.textColor = [UIColor grayPandroColor];
        
        _addTitleLabel.text = NSLocalizedString(@"group", @"group");
    }
    return _addTitleLabel;
}


@end



@interface LampPortalCellView ()
{
    float cellNoExpandHeight;
}

@property(nonatomic, strong)LampPortalModel *portalModel;

@property(nonatomic, strong)UIView *backgroundTmpView;
@property(nonatomic, strong)UIView *separateView;

@property(nonatomic, strong)UIImageView *iconView;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)PandroButton *controlBtn;
@property(nonatomic, strong)PandroButton *managerBtn;
@property(nonatomic, strong)PandroButton *deleteBtn;



@end


@implementation LampPortalCellView


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cellNoExpandHeight = 44;
    [self addSubview:self.backgroundTmpView];
    [self addSubview:self.separateView];
    
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.controlBtn];
    [self addSubview:self.managerBtn];
    [self addSubview:self.deleteBtn];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //background
    float leftOffset = 5;
    self.backgroundTmpView.frame = CGRectMake(leftOffset, 0, self.frame.size.width - 2 * leftOffset, self.frame.size.height - 5);
    if (self.portalModel.expand)
    {
        [self.separateView setHidden:NO];
        self.separateView.frame = CGRectMake(leftOffset, cellNoExpandHeight, self.frame.size.width - 2 * leftOffset, 0.5);
    }
    else
    {
        [self.separateView setHidden:YES];
    }
    
    //content
    leftOffset = 15;
    float tmpWidth = 20;
    CGRect rect = CGRectMake(leftOffset, (cellNoExpandHeight-tmpWidth)/2, tmpWidth, tmpWidth);
    self.iconView.frame = rect;
    
    rect = CGRectMake(self.iconView.frame.origin.x + self.iconView.frame.size.width + 10, 0, self.frame.size.width/2, cellNoExpandHeight);
    self.nameLabel.frame = rect;
    
    rect = CGRectMake((self.frame.size.width - cellNoExpandHeight)/2, cellNoExpandHeight, cellNoExpandHeight, cellNoExpandHeight);
    self.managerBtn.frame = rect;
    
    rect = CGRectMake(self.frame.size.width - cellNoExpandHeight - leftOffset, cellNoExpandHeight, cellNoExpandHeight, cellNoExpandHeight);
    self.deleteBtn.frame = rect;
    
    if (self.portalModel.expand)
    {
        [self.controlBtn setHidden:NO];
        
        if (self.portalModel.allDevice)
        {
            [self.managerBtn setHidden:YES];
            [self.deleteBtn setHidden:YES];
            
            rect = CGRectMake((self.frame.size.width - cellNoExpandHeight)/2, cellNoExpandHeight, cellNoExpandHeight, cellNoExpandHeight);
            self.controlBtn.frame = rect;
        }
        else
        {
            [self.managerBtn setHidden:NO];
            [self.deleteBtn setHidden:NO];
            
            rect = CGRectMake(leftOffset, cellNoExpandHeight, cellNoExpandHeight, cellNoExpandHeight);
            self.controlBtn.frame = rect;
        }
    }
    else
    {
        [self.controlBtn setHidden:YES];
        [self.managerBtn setHidden:YES];
        [self.deleteBtn setHidden:YES];
    }
    
}

#pragma mark fun
-(void)showContentFromModel:(LampPortalModel *)model
{
    self.portalModel = model;
    
    if (model.allDevice)
    {
        self.iconView.image = [UIImage loadImageWithName:@"groupList_icon_allDevice_19x19_"];
        self.nameLabel.text = @"所有设备";
    }
    else
    {
        self.iconView.image = [UIImage loadImageWithName:@"groupList_icon_allGroup_19x19_"];
        self.nameLabel.text = model.placeModel.name;
    }
    
    
}
-(void)clickedPandroButton:(PandroButton *)button
{
    if ([button isEqual:self.controlBtn])
    {
        [self clickedPandroButtonOfControl];
    }
    else if ([button isEqual:self.managerBtn])
    {
        [self clickedPandroButtonOfManage];
    }
    else if ([button isEqual:self.deleteBtn])
    {
        [self clickedPandroButtonOfDelete];
    }
}

-(void)clickedPandroButtonOfControl
{
    if ([self.delegate respondsToSelector:@selector(clickedCellControl:model:)])
    {
        [self.delegate clickedCellControl:self model:self.portalModel];
    }
}
-(void)clickedPandroButtonOfManage
{
    if ([self.delegate respondsToSelector:@selector(clickedCellManage:model:)])
    {
        [self.delegate clickedCellManage:self model:self.portalModel];
    }
}
-(void)clickedPandroButtonOfDelete
{
    if ([self.delegate respondsToSelector:@selector(clickedCellDelete:model:)])
    {
        [self.delegate clickedCellDelete:self model:self.portalModel];
    }
}

#pragma mark setter and getter
-(UIView *)separateView
{
    if (!_separateView)
    {
        _separateView = [[UIView alloc] initWithFrame:CGRectZero];
        _separateView.backgroundColor = [UIColor littleBlackPandroColor];
        
    }
    return _separateView;
}

-(UIView *)backgroundTmpView
{
    if (!_backgroundTmpView)
    {
        _backgroundTmpView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundTmpView.backgroundColor = [UIColor secondBlackPandroColor];
    }
    
    return _backgroundTmpView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

-(UIImageView *)iconView
{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.backgroundColor = [UIColor clearColor];
    }
    return _iconView;
}

-(PandroButton *)controlBtn
{
    if (!_controlBtn)
    {
        CGRect rect = CGRectMake(0, 0, cellNoExpandHeight, cellNoExpandHeight);
        _controlBtn = [[PandroButton alloc] initWithTitle:@"控制" image:@"groupList-group_control_18x18_" frame:rect];
        _controlBtn.delegate = self;
    }
    return _controlBtn;
}

-(PandroButton *)managerBtn
{
    if (!_managerBtn)
    {
        CGRect rect = CGRectMake(0, 0, cellNoExpandHeight, cellNoExpandHeight);
        _managerBtn = [[PandroButton alloc] initWithTitle:@"管理" image:@"groupList-group_manage_18x18_" frame:rect];
        _managerBtn.delegate = self;
    }
    return _managerBtn;
}

-(PandroButton *)deleteBtn
{
    if (!_deleteBtn)
    {
        CGRect rect = CGRectMake(0, 0, cellNoExpandHeight, cellNoExpandHeight);
        _deleteBtn = [[PandroButton alloc] initWithTitle:@"删除" image:@"groupList_group_delete_18x18_" frame:rect];
        _deleteBtn.delegate = self;
    }
    return _deleteBtn;
}

@end
