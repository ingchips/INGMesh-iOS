//
//  MeshAreaListViewController.m
//  Pandro
//
//  Created by chun on 2018/12/24.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshAreaListViewController.h"
#import "MeshPlaceDatabase.h"
#import "MeshAreaListCell.h"

@interface MeshAreaListViewController ()

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *addBtnView;


@property(nonatomic, strong)MeshPlaceModel *placeModel;

@end

@implementation MeshAreaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.addBtnView];
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
    
    [self processCommand:self.pageCommand params:self.pageParams];
    
}

-(void)processCommand:(NSString *)command params:(NSDictionary *)params
{
    if ([command isEqualToString:@"init"])
    {
        [self processCommandForContent:[params valueForKey:@"placeId"]];
    }
}
-(void)processCommandForContent:(NSString *)placeId
{
    MeshPlaceModel *placeModel = [[MeshPlaceDatabase shareInstance] placeModelFromPlaceId:placeId];
    if (!placeModel)
    {
        return;
    }
    self.placeModel = placeModel;
    [self.tableView reloadData];
}


#pragma mark click
-(void)clickAddArea:(id)sender
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.placeModel.placeId forKey:@"placeId"];
    
    [self gotoPage:PAGE_AREA_ADD_VIEWCONTROLLER params:dict command:@"init"];
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeModel.areaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    MeshAreaListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[MeshAreaListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
    }
    
    [cell showContentFromModel:[self.placeModel.areaArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MeshAreaModel *areaModel = [self.placeModel.areaArray objectAtIndex:indexPath.row];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.placeModel.placeId forKey:@"placeId"];
    [dict setValue:areaModel.areaId forKey:@"areaId"];
    [dict setValue:areaModel.name forKey:@"name"];
    
    [self gotoPage:PAGE_DEVICE_ASSIGN_VIEWCONTROLLER params:dict command:@"init"];
    
}



#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIControl *)addBtnView
{
    if (!_addBtnView)
    {
        CGRect rect = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 180, 50, 50);
        _addBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtnView.frame = rect;
        [_addBtnView setImage:[UIImage loadImageWithName:@"ic_add"] forState:UIControlStateNormal];
        [_addBtnView addTarget:self action:@selector(clickAddArea:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtnView;
    
}

@end
