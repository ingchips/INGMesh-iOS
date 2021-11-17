//
//  LampMeshViewController.m
//  Pandro
//
//  Created by chun on 2019/3/1.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampMeshViewController.h"
#import "LampMeshViewGroupModel.h"
#import "MeshPlaceDatabase.h"
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"
#import "LampMeshGroupCell.h"
#import "LampMeshDeviceCell.h"

#import "LampGroupSetNameView.h"
#import "PandroBlueToothMeshMgrBridge.h"
#import "PandroBlueToothMeshMgrOC.h"


@interface LampMeshViewController ()<LampMeshDeviceCellDelegate,LampMeshGroupCellDelegate>

@property(nonatomic, strong)NSMutableArray *groupArray;
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)MeshPlaceModel *placeModel;
@property(nonatomic, strong)NSString *proxyName;
@property(retain,nonatomic) NSTimer* nsTime;

@end

@implementation LampMeshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProxyName:) name:@"ProxyName" object:nil];
    [self showNavBarTitle:@"智能灯组"];
    [self.navBar.rightBtn setImage:[UIImage loadImageWithName:@"lamp_mesh_add_group"] forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(clickAddGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    
    _nsTime = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_nsTime invalidate];
    _nsTime = nil;

}
-(void)updateTime:(NSTimer*) timer{
    if((NSNull *)self.proxyName == [NSNull null] ||  self.proxyName.length < 1)
    {
        [[PandroBlueToothMeshMgrOC shareInstance] getProxyName];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [[PandroBlueToothMeshMgrOC shareInstance] getProxyName];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self loadContentData];
}
-(void)ProxyName:(NSNotification *)notification
{
    self.proxyName = notification.userInfo[@"ProxyName"];
    __weak __typeof(self) weakself= self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView reloadData];
    });
}
#pragma mark fun
-(void)loadContentData
{
    self.groupArray = [[NSMutableArray alloc] init];
    
    
    [[PandroBlueToothMeshMgrOC shareInstance] myDevice];

    //all device group
    LampMeshViewGroupModel *groupModel = [[LampMeshViewGroupModel alloc] init];
    groupModel.allDeviceGroup = YES;
    
    for (MeshPlaceModel *placeModel in [MeshPlaceDatabase shareInstance].placeArray)
    {
        if (placeModel.favorite)
        {
            self.placeModel = placeModel;
            
            [self.placeModel.deviceArray removeAllObjects];
            
            for (NSDictionary *dicDevice in [PandroBlueToothMeshMgrBridge shareInstance].myDeviceArr)
               {
                   NSString *name = @"设备1";
                   NSString *deviceId = @"111111";

                   if([dicDevice objectForKey:@"name"] && [[dicDevice objectForKey:@"name"] length] > 0)
                   {
                      name = [dicDevice objectForKey:@"name"];
                   }
                   if([dicDevice objectForKey:@"uuid"] && [[dicDevice objectForKey:@"uuid"] length] > 0)
                   {
                      deviceId = [dicDevice objectForKey:@"uuid"];
                   }
                   MeshDeviceModel *mesh = [[MeshDeviceModel alloc] init];
                   mesh.name = name;
                   mesh.deviceId = deviceId;
                   [self.placeModel.deviceArray addObject:mesh];
                   NSLog(@"device array meshview controller %@ %d",mesh.name,self.placeModel.deviceArray.count);
//                   [[MeshPlaceDatabase shareInstance] addDeviceForPlace:self.placeModel.placeId deviceName:name];
               }
            
            break;
        }
    }
    [self.groupArray addObject:groupModel];
    groupModel.deviceArray = self.placeModel.deviceArray;

    //group name
    for (MeshAreaModel *areaModel in self.placeModel.areaArray)
    {
        LampMeshViewGroupModel *groupModel = [[LampMeshViewGroupModel alloc] init];
        groupModel.areaModel = areaModel;
        groupModel.deviceArray = areaModel.deviceArray;
        
        [self.groupArray addObject:groupModel];
    }
    
    //reload
    [self.tableView reloadData];
    
}

-(void)clickAddGroup:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navBar.frame.size.height);
    LampGroupSetNameView *nameView = [[LampGroupSetNameView alloc] initWithFrame:rect groupName:nil];
    
    rect.origin.y = self.view.frame.size.height;
    nameView.frame = rect;
    
    nameView.nameTipLabel.text = @"输入新组名称";
    nameView.textField.placeholder = @"输入新组名称";
    
    [self.view addSubview:nameView];
    __block CGRect animRect = rect;
    [UIView animateWithDuration:0.1 animations:^{
        //
        animRect.origin.y = weakSelf.navBar.frame.size.height;
        nameView.frame = animRect;
    }];
    
    nameView.clickedBlock = ^BOOL(NSString *name) {
        return [weakSelf clickAddBtn_innerName:name];
    };
}

-(BOOL)clickAddBtn_innerName:(NSString *)name
{
    if (!name || name.length == 0)
    {
        [self.view showAnimationTip:@"输入新组名称" topOffset:0];
        return NO;
    }
    
    NSString *addTip = [[MeshPlaceDatabase shareInstance] addAreaForPlace:self.placeModel.placeId areaName:name];
    if (!addTip)
    {
        [self loadContentData];
        return YES;
    }
    [self.view showAnimationTip:addTip topOffset:0];
    return NO;
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
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
    if (indexPath.row == 0)
    {
        return 66;
    }
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LampMeshViewGroupModel *groupModel = [self.groupArray objectAtIndex:section];

    if (groupModel.showExpand)
    {
        return 1 + groupModel.deviceArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSString *identifierForCell = @"identifierForCellGroup";
        
        LampMeshGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
        if (!cell)
        {
            cell = [[LampMeshGroupCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierForCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        LampMeshViewGroupModel *groupModule = [self.groupArray objectAtIndex:indexPath.section];
        cell.nameStr = self.proxyName;
        cell.indexPath = indexPath;
        cell.lampMeshGroupDeviceCellDelegate = self;
        [cell showContentFromModule:groupModule];
        cell.placeId = self.placeModel.placeId;
        
        return cell;
    }
    NSString *identifierForCell = @"identifierForCell";
    
    LampMeshDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[LampMeshDeviceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.placeModel = self.placeModel;
    LampMeshViewGroupModel *groupModule = [self.groupArray objectAtIndex:indexPath.section];
    MeshDeviceModel *deviceModule = [groupModule.deviceArray objectAtIndex:indexPath.row - 1];
    cell.nameStr = self.proxyName;
    cell.indexPath = indexPath;
    cell.lampMeshDeviceCellDelegate = self;
    [cell showContentFromModule:deviceModule];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LampMeshViewGroupModel *groupModule = [self.groupArray objectAtIndex:indexPath.section];
        groupModule.showExpand = !groupModule.showExpand;
        
        [tableView reloadData];
        
        return;
    }
    else
    {
        printf("device count %i\n",[PandroBlueToothMeshMgrBridge shareInstance].myDeviceArr.count);
        if ([PandroBlueToothMeshMgrBridge shareInstance].myDeviceArr.count < 1) {
            [self.view showAnimationTip:@"没有已经入网的设备，请添加设备后操作" topOffset:0];
            return;
        }
        if ((NSNull *)self.groupArray == [NSNull null]){
            [[PandroBlueToothMeshMgrOC shareInstance] getProxyName];
             [self.view showAnimationTip:@"没有正在链接中的设备，请链接设备后再试" topOffset:0];
             return;
        }
        
        LampMeshViewGroupModel *groupModel = [self.groupArray objectAtIndex:indexPath.section];
        
        MeshDeviceModel *deviceModel = [groupModel.deviceArray objectAtIndex:(indexPath.row - 1)];
        NSString *deviceId = deviceModel.deviceId;
        
        MeshAreaModel *areaModel = groupModel.areaModel;
        NSString *areaId = areaModel.areaId;
        
        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
        [dictItem setValue:self.placeModel.placeId forKey:@"placeId"];
        [dictItem setValue:deviceId forKey:@"deviceId"];
        [dictItem setValue:areaId forKey:@"areaId"];
        [dictItem setValue:self.placeModel.deviceArray forKey:@"devicesArr"];

        
        [self gotoPage:PAGE_LAME_DEVICE_SET_VC params:dictItem command:@"init"];
        
    }
}


#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(5, self.navBar.frame.size.height, self.view.frame.size.width-10, self.view.frame.size.height - self.navBar.frame.size.height);
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


- (void)selectedItemButton:(NSIndexPath*)indexPath{
    LampMeshViewGroupModel *groupModule = [self.groupArray objectAtIndex:indexPath.section];
    BOOL isGroup = YES;
    for (MeshDeviceModel *deviceModel in groupModule.deviceArray) {
        if (!deviceModel.switchOn) {
            isGroup = deviceModel.switchOn;
            break;
        }
    }
    groupModule.isOn = isGroup;
    

    for (MeshDeviceModel *deviceModel in groupModule.deviceArray) {
        for (LampMeshViewGroupModel *groupModuleOne in self.groupArray) {
               for (MeshDeviceModel *deviceModelOne in groupModuleOne.deviceArray) {
                   if ([deviceModel.deviceId isEqualToString:deviceModelOne.deviceId]) {
                       deviceModelOne.switchOn = deviceModel.switchOn;
                     }
                 }
          }
    }
    
    for (LampMeshViewGroupModel *groupModuleOne in self.groupArray) {
        BOOL isGroup = YES;
        for (MeshDeviceModel *deviceModelOne in groupModuleOne.deviceArray) {
            if (!deviceModelOne.switchOn) {
                isGroup = deviceModelOne.switchOn;
                break;
            }
        }
        if (groupModuleOne.deviceArray.count == 0) {
                      isGroup = NO;
        }
        groupModuleOne.isOn = isGroup;
    }
    [self.tableView reloadData];
}
- (void)selectedGroupItemButton:(NSIndexPath*)indexPath{
    LampMeshViewGroupModel *groupModule = [self.groupArray objectAtIndex:indexPath.section];
    for (MeshDeviceModel *deviceModel in groupModule.deviceArray) {
        deviceModel.switchOn = groupModule.isOn;
    }
    
    for (MeshDeviceModel *deviceModel in groupModule.deviceArray) {
           for (LampMeshViewGroupModel *groupModuleOne in self.groupArray) {
                  for (MeshDeviceModel *deviceModelOne in groupModuleOne.deviceArray) {
                      if ([deviceModel.deviceId isEqualToString:deviceModelOne.deviceId]) {
                          deviceModelOne.switchOn = deviceModel.switchOn;
                        }
                    }
             }
       }
       
       for (LampMeshViewGroupModel *groupModuleOne in self.groupArray) {
           BOOL isGroup = YES;
           for (MeshDeviceModel *deviceModelOne in groupModuleOne.deviceArray) {
               if (!deviceModelOne.switchOn) {
                   isGroup = deviceModelOne.switchOn;
                   break;
               }
           }
           if (groupModuleOne.deviceArray.count == 0) {
               isGroup = NO;
           }
           groupModuleOne.isOn = isGroup;
       }
    [self.tableView reloadData];
}
- (void)dealloc
{
    [_nsTime invalidate];
    _nsTime = nil;

}
@end
