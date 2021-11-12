//
//  LampPortalViewController.m
//  Pandro
//
//  Created by chun on 2019/1/15.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalViewController.h"
#import "LampPortalView.h"
#import "LampPortalModel.h"
#import "MeshPlaceDatabase.h"

@interface LampPortalViewController ()

@property(nonatomic, strong)NSMutableArray *modelArray;
@property(nonatomic, strong)LampPortalModel *allDeviceModel;

@property(nonatomic, strong)LampPortalHeaderView *headerView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *showBtnView;

@property(nonatomic)BOOL showGrop;
@property(nonatomic)int expandIndex;

@end

@implementation LampPortalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarTitle:@"容器"];
    self.showGrop = YES;
    self.expandIndex = -1;
    
    [self initDataContent];
    
    //init view
    UIImage *image = [UIImage loadImageWithName:@"nav_bar_icon_set_30x30_"];
    [self.navBar.leftBtn setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark fun
-(void)initDataContent
{
    self.modelArray = [[NSMutableArray alloc] init];
    
    self.allDeviceModel = [[LampPortalModel alloc] init];
    self.allDeviceModel.allDevice = YES;
    [self.modelArray addObject:self.allDeviceModel];
    
    if (!self.showGrop)
    {
        return;
    }
    self.expandIndex = -1;
    NSArray *array = [MeshPlaceDatabase shareInstance].placeArray;
    for (MeshPlaceModel *placeModel in array)
    {
        LampPortalModel *lampModel = [[LampPortalModel alloc] init];
        lampModel.placeModel = placeModel;
        [self.modelArray addObject:lampModel];
    }
    
}


#pragma mark click
-(void)clickLeftBtn
{
    [self gotoPage:PAGE_LAME_PORTAL_SET_VC params:nil command:nil];
}

#pragma mark LampPortalHeaderViewDelegate
-(void)clickedAddGroup:(LampPortalHeaderView *)headerView
{
    int nNameIndex = 1;
    
    NSArray *array = [MeshPlaceDatabase shareInstance].placeArray;
    for (int i=1; i <= (array.count + 1); i++)
    {
        NSString *nameTmp = [NSString stringWithFormat:@"群组%d", i];
        if (![[MeshPlaceDatabase shareInstance] checkContainPlaceName:nameTmp])
        {
            nNameIndex = i;
        }
    }
    
    NSString *nameTmp = [NSString stringWithFormat:@"群组%d", nNameIndex];
    
    [[MeshPlaceDatabase shareInstance] addPlace:nameTmp];
    self.headerView.addTitleLabel.text = nameTmp;
    
    self.showGrop = YES;
    
    [self initDataContent];
    [self.tableView reloadData];
    
    [self showAllGroupInTableview:self.showGrop];
    
}
-(void)clickedShowGroup:(LampPortalHeaderView *)headerView
{
    self.showGrop = !self.showGrop;
    
    [self initDataContent];
    [self.tableView reloadData];
    
    [self showAllGroupInTableview:self.showGrop];
}

-(void)showAllGroupInTableview:(BOOL)show
{
    [self.headerView showAllGroupInTableview:show];
}

#pragma mark cell delegate
-(void)clickedCellControl:(LampPortalCellView *)cell model:(LampPortalModel *)model
{
    NSString *placeId = nil;
    if (!model.allDevice)
    {
        placeId = model.placeModel.placeId;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:placeId forKey:@"placeId"];
    [self gotoPage:PAGE_LAME_DEVICE_SET_VC params:dict command:@"init"];
    
}

-(void)clickedCellManage:(LampPortalCellView *)cell model:(LampPortalModel *)model
{
    NSString *placeId = nil;
    if (!model.allDevice)
    {
        placeId = model.placeModel.placeId;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:placeId forKey:@"placeId"];
    [self gotoPage:PAGE_LAME_GROUP_SET_VC params:dict command:@"init"];
}

-(void)clickedCellDelete:(LampPortalCellView *)cell model:(LampPortalModel *)model
{
    self.expandIndex = -1;
    
    [[MeshPlaceDatabase shareInstance] deletePlaceWithPlace:model.placeModel];
    
    [self initDataContent];
    [self.tableView reloadData];

}


#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.expandIndex)
    {
        return 88 + 5;
    }
    return 44 + 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    LampPortalCellView *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[LampPortalCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.delegate = self;
    }
    
    [cell showContentFromModel:[self.modelArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //last
    if (self.expandIndex >= 0 && self.expandIndex < self.modelArray.count)
    {
        LampPortalModel *model = [self.modelArray objectAtIndex:self.expandIndex];
        model.expand = NO;
    }
    
    //new
    LampPortalModel *model = [self.modelArray objectAtIndex:indexPath.row];
    if (self.expandIndex == indexPath.row)
    {
        model.expand = NO;
        
        self.expandIndex = -1;
    }
    else
    {
        model.expand = YES;
        
        self.expandIndex = indexPath.row;
    }
    
    
    [self.tableView reloadData];
    
}



#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
    
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
        LampPortalHeaderView *headerView = [[LampPortalHeaderView alloc] initWithFrame:rect];
        headerView.delegate = self;
        self.headerView = headerView;
        
        _tableView.tableHeaderView = headerView;
        
    }
    return _tableView;
}

-(UIButton *)addBtnView
{
    if (!_showBtnView)
    {
        CGRect rect = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 180, 50, 50);
        _showBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBtnView.frame = rect;
        [_showBtnView setImage:[UIImage loadImageWithName:@"ic_add"] forState:UIControlStateNormal];
        [_showBtnView addTarget:self action:@selector(clickAddPlace:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtnView;
    
}


@end
