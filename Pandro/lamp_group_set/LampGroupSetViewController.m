//
//  LampGroupSetViewController.m
//  Pandro
//
//  Created by chun on 2019/1/15.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampGroupSetViewController.h"
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshPlaceDatabase.h"

#import "LampGroupSetNameView.h"
#import "LampGroupSetIconView.h"
#import "PandroBlueToothMeshMgrOC.h"


@interface LampGroupSetViewController ()
{
    float sectionHeaderHeight;
    float cellHeight;
}

@property(nonatomic, strong)MeshPlaceModel *placeModel;
@property(nonatomic, strong)MeshAreaModel *areaModel;

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *deviceArray;

@end

@implementation LampGroupSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionHeaderHeight = 15;
    cellHeight = 56;
    
    [self showNavBarTitle:@"分组设置"];
    
    [self.view addSubview:self.tableView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除群组" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn.layer setCornerRadius:10];
    [deleteBtn.layer setMasksToBounds:YES];
    float topOffset = self.tableView.frame.size.height + self.tableView.frame.origin.y + 20;
    deleteBtn.frame = CGRectMake(15, topOffset, self.view.frame.size.width - 30, 48);
    [deleteBtn addTarget:self action:@selector(clickDeleteGroupBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.pageCommand isEqualToString:@"init"])
    {
        NSString *placeId = [self.pageParams valueForKey:@"placeId"];
        self.placeModel = [[MeshPlaceDatabase shareInstance] placeModelFromPlaceId:placeId];
        
        NSLog(@"== %@", self.placeModel);
        
        NSString *areaId = [self.pageParams valueForKey:@"areaId"];
        for (MeshAreaModel *areaModel in self.placeModel.areaArray)
        {
            if ([areaModel.areaId isEqualToString:areaId])
            {
                self.areaModel = areaModel;
                break;
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark fun
-(void)clickDeleteGroupBtn:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除该分组么？" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertCon dismissViewControllerAnimated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            [weakSelf clickDeleteGroupBtn_inner];
        }];
        
        //
    }];
    [alertCon addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alertCon addAction:cancelAction];
    
    
    [self presentViewController:alertCon animated:YES completion:^{
        //
    }];
}

-(void)clickDeleteGroupBtn_inner
{
    [[PandroBlueToothMeshMgrOC shareInstance] removeGroupAndName:self.areaModel.name];

    [[MeshPlaceDatabase shareInstance] deleteAreaForPlace:self.placeModel.placeId areaId:self.areaModel.areaId];
    
    [self popPage:nil command:nil];
}


-(void)clickGroupSetName
{
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navBar.frame.size.height);
    LampGroupSetNameView *nameView = [[LampGroupSetNameView alloc] initWithFrame:rect groupName:self.placeModel.name];
    
    rect.origin.y = self.view.frame.size.height;
    nameView.frame = rect;
    
    nameView.textField.placeholder = self.areaModel.name;
    
    [self.view addSubview:nameView];
    __block CGRect animRect = rect;
    [UIView animateWithDuration:0.1 animations:^{
        //
        animRect.origin.y = weakSelf.navBar.frame.size.height;
        nameView.frame = animRect;
    }];
    
    nameView.clickedBlock = ^BOOL(NSString *name) {
        //
        return [weakSelf clickGroupSetName_Inner:name];
    };
    
}
-(BOOL)clickGroupSetName_Inner:(NSString *)name
{
    NSString *strName = [NSString stringWithFormat:@"%@",self.areaModel.name];
    
    BOOL exist = [[MeshPlaceDatabase shareInstance] updateAreaForPlace:self.placeModel.placeId areaId:self.areaModel.areaId areaName:name];
    if (exist)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"name has exist" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:0 handler:^(UIAlertAction * action) {
            //
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            //
        }];
        
        return NO;
    }
    [[PandroBlueToothMeshMgrOC shareInstance] modifyGroupAndName:strName withNewName:name];
    self.areaModel.name = name;
    [[MeshPlaceDatabase shareInstance] savaDatabase];
    
    [self.tableView reloadData];
    
    return YES;
}

-(void)clickGroupSetIcon
{
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navBar.frame.size.height);
    LampGroupSetIconView *nameView = [[LampGroupSetIconView alloc] initWithFrame:rect groupIcon:self.placeModel.iconName];
    
    rect.origin.y = self.view.frame.size.height;
    nameView.frame = rect;
    
    [self.view addSubview:nameView];
    __block CGRect animRect = rect;
    [UIView animateWithDuration:0.1 animations:^{
        //
        animRect.origin.y = weakSelf.navBar.frame.size.height;
        nameView.frame = animRect;
    }];
    
    nameView.clickedBlock = ^BOOL(NSString *name) {
        //
        return [weakSelf clickGroupSetIcon_Inner:name];
    };
}

-(BOOL)clickGroupSetIcon_Inner:(NSString *)iconName
{
    self.areaModel.iconName = iconName;
    [[MeshPlaceDatabase shareInstance] savaDatabase];
    
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
        
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGRect rect = CGRectMake(15, (cellHeight - 18)/2, 18, 18);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = 1001;
        [cell addSubview:imageView];
        
        float leftOffset = imageView.frame.origin.x  + imageView.frame.size.width + 15;
        rect = CGRectMake(leftOffset, 0, self.view.frame.size.width -leftOffset -  100, cellHeight);
        UILabel *labelTmp = [[UILabel alloc] initWithFrame:rect];
        labelTmp.backgroundColor = [UIColor clearColor];
        labelTmp.font = [UIFont systemFontOfSize:15];
        labelTmp.textColor = [UIColor blackPandroColor];
        labelTmp.tag = 1002;
        [cell addSubview:labelTmp];
        
        //A9AEBD
        leftOffset = self.tableView.frame.size.width/2;
        float rightOffset = self.tableView.frame.size.width - 35;
        rect = CGRectMake(leftOffset, 0, rightOffset - leftOffset, cellHeight);
        labelTmp = [[UILabel alloc] initWithFrame:rect];
        labelTmp.backgroundColor = [UIColor clearColor];
        labelTmp.font = [UIFont systemFontOfSize:15];
        labelTmp.textAlignment = NSTextAlignmentRight;
        labelTmp.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
        labelTmp.tag = 1003;
        [cell addSubview:labelTmp];
        
        
        rightOffset = self.tableView.frame.size.width - 30 - 40;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(rightOffset, (cellHeight - 35)/2, 35, 35)];
        iconView.tag = 1004;
        [cell addSubview:iconView];
        
    }
    
    UILabel *labelTip = [cell viewWithTag:1003];
    [labelTip setHidden:YES];
    
    UIImageView *iconImgView = [cell viewWithTag:1004];
    [iconImgView setHidden:YES];
    
    NSString *imgName = nil;
    NSString *cellText = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            imgName = @"group_set_icon_set_name";
            cellText = @"分组名称";
            
            [labelTip setHidden:NO];
            labelTip.text = self.areaModel.name;
        }
        else
        {
            imgName = @"group_set_icon_set_icon";
            cellText = @"分组图标";
            
            [iconImgView setHidden:NO];
            iconImgView.image = [UIImage loadImageWithName:self.areaModel.iconName];
        }
    }
    else
    {
        imgName = @"group_set_icon_set_device";
        cellText = @"已添加设备";
        
        [labelTip setHidden:NO];
        labelTip.text = [NSString stringWithFormat:@"%d个", self.areaModel.deviceArray.count];
    }
    UIImageView *imgView = [cell viewWithTag:1001];
    imgView.image = [UIImage loadImageWithName:imgName];
    
    UILabel *labelNameTag = [cell viewWithTag:1002];
    labelNameTag.text = cellText;
    
    
    /*
    
    NSString *text = @"";
    UILabel *labelNameTag = [cell viewWithTag:1001];
    [labelNameTag setHidden:YES];
    
    UIImageView *imageView = [cell viewWithTag:1002];
    [imageView setHidden:YES];
    
    if (indexPath.row == 0)
    {
        [labelNameTag setHidden:NO];
        labelNameTag.text = self.placeModel.name;
        
        text = @"群组名称";
    }
    else if (indexPath.row == 1)
    {
        [imageView setHidden:NO];
        
        UIImageView *iconView = [cell viewWithTag:1003];
        if (self.placeModel.iconName)
        {
            iconView.image = [UIImage loadImageWithName:self.placeModel.iconName];
        }
        else
        {
            iconView.image = [UIImage loadImageWithName:@"groupList_icon_allGroup_19x19_"];
        }
        
        text = @"群组图表";
    }
    
    cell.textLabel.text = text;
    */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self clickGroupSetName];
        }
        else if (indexPath.row == 1)
        {
            [self clickGroupSetIcon];
        }
    }
    else
    {
        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
        [dictItem setValue:self.placeModel.placeId forKey:@"placeId"];
        [dictItem setValue:self.areaModel.areaId forKey:@"areaId"];
        [self gotoPage:PAGE_LAME_GROUP_SET_DEVICE_VC params:dictItem command:@"init"];
    }
}

#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(15, self.navBar.frame.size.height, self.view.frame.size.width-30, 220);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor littleGrayPandroColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.shadowColor = [UIColor bluePandroColor].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(5, 5);
        _tableView.layer.shadowRadius = 2;
        _tableView.layer.shadowOpacity = 0.2;
        
    }
    return _tableView;
}


@end
